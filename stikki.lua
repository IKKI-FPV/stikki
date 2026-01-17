local ail, ele, rud, thr

-- =============================================================
--        CONFIGURAZIONE UTENTE
-- =============================================================

-- 1. SORGENTI DI CONTROLLO
local SRC_MENU_TRIGGER = "sf" -- Interruttore per il doppio click (Menu)
local SRC_POT_1        = "s1" -- Potenziometro 1 (Funzione variabile in base al livello)
local SRC_POT_2        = "s2" -- Potenziometro 2 (Funzione variabile in base al livello)

-- 2. SCAMBIO STICK
local SCAMBIA_ANELLI = true

-- 3. INVERSIONE ASSI
local INV_GAS     = true 
local INV_PICCHIA = false   
local INV_ALETTONI= true
local INV_TIMONE  = false

-- 4. ZONA MORTA & BATTITO
local DEAD_ZONE_HIGH = 0.18
local DEAD_ZONE_LOW  = 0.08
local AXIS_LOCK      = 0.05
local MAX_VELOCITA   = 1.6   -- Velocità massima rotazione larsen

-- 5. VALORI DI DEFAULT (Partenza a freddo)
local DEF_THEME_HUE   = 0.80  -- Viola
local DEF_PTR_HUE     = 0.50  -- Azzurro/Ciano
local DEF_HEART_BRIGHT= 1.00  -- 100%
local DEF_PTR_BRIGHT  = 1.00  -- 100%
local DEF_BPM         = 35   -- Battiti al minuto
local DEF_PAUSE_RATIO = 0.5   -- Bilanciamento pausa

-- =============================================================
--           FINE CONFIGURAZIONE
-- =============================================================

local phase_left = 0
local phase_right = 0
local last_time = 0

-- Variabili di stato per isteresi
local is_active_left = false
local is_active_right = false

-- ==========================================
-- GESTIONE MEMORIA & MENU
-- ==========================================
local menu_level = 0 -- 0=OFF, 1=COLORI, 2=LUMINOSITA, 3=TEMPO
-- Parametri salvati
local p_theme_hue    = DEF_THEME_HUE
local p_ptr_hue      = DEF_PTR_HUE
local p_heart_bright = DEF_HEART_BRIGHT
local p_ptr_bright   = DEF_PTR_BRIGHT
local p_bpm          = DEF_BPM
local p_pause_ratio  = DEF_PAUSE_RATIO

-- Gestione Doppio Click
local last_sw_val = 0
local last_click_time = 0
local click_count = 0

-- Gestione Feedback Flash
local flash_active = false
local flash_end_time = 0
local flash_color_r = 0
local flash_color_g = 0
local flash_color_b = 0
local flash_pattern_count = 0 
local flash_next_toggle = 0
local flash_state_on = false

-- GESTIONE SOFT-LOCK (Nuovo: Previene salti accidentali)
-- Quando cambi menu, queste variabili bloccano i potenziometri
-- finché non vengono mossi intenzionalmente.
local s1_locked = false
local s2_locked = false
local s1_lock_pos = 0 -- Posizione fisica al momento del cambio menu
local s2_lock_pos = 0
local LOCK_TOLERANCE = 60 -- Soglia movimento per sbloccare (su 2048 punti)

-- Variabili Calcolate (RGB)
local rgb_theme_r, rgb_theme_g, rgb_theme_b
local rgb_ptr_r, rgb_ptr_g, rgb_ptr_b
local rgb_heart_r, rgb_heart_g, rgb_heart_b

-- Funzione di utilità: Converte HSV a RGB
local function hsvToRgb(h, s, v)
  h = h - math.floor(h)
  local r, g, b
  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)
  i = i % 6
  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end
  return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

local function mapRange(val, min_out, max_out)
    local norm = (val + 1024) / 2048 
    return min_out + (norm * (max_out - min_out))
end

-- ==========================================
-- LOGICA BATTITO & LARSEN
-- ==========================================

local function getHeartbeatIntensity(time_sec)
    local beat_duration = 60 / p_bpm 
    local t = (time_sec % beat_duration) / beat_duration 
    
    local intensity = 0
    
    -- PRIMO BATTITO
    if t < 0.15 then
        intensity = math.sin((t / 0.15) * 3.14159)
        
    -- SECONDO BATTITO
    elseif t >= 0.20 then
        local base_fall = 0.35
        local extra_fall = p_pause_ratio * 0.4 
        local fall_time = base_fall + extra_fall
        
        local rise_time = 0.075
        local t2 = t - 0.20
        
        if t2 < rise_time then
            intensity = math.sin((t2 / rise_time) * (3.14159 / 2))
        elseif t2 < (rise_time + fall_time) then
            local t_fall = t2 - rise_time
            local progress = t_fall / fall_time
            intensity = math.cos(progress * (3.14159 / 2))
        end
    end
    
    if intensity < 0 then intensity = 0 end
    return intensity
end

local function updateHysteresisState(current_state, magnitude)
    if current_state == false then
        if magnitude > DEAD_ZONE_HIGH then return true end
    else
        if magnitude < DEAD_ZONE_LOW then return false end
    end
    return current_state
end

local function triggerFlash(count, r, g, b, now)
    flash_active = true
    flash_pattern_count = count * 2
    flash_color_r = r
    flash_color_g = g
    flash_color_b = b
    flash_next_toggle = now
    flash_state_on = false
end

local function drawRing(ring_index, h, v, phase, absolute_time, is_active)
  -- Feedback Flash Menu
  if flash_active then
     if flash_state_on then
         for i = 0, 9 do
            setRGBLedColor(i + (ring_index * 10), flash_color_r, flash_color_g, flash_color_b)
         end
     else
         for i = 0, 9 do
            setRGBLedColor(i + (ring_index * 10), 0, 0, 0)
         end
     end
     return
  end

  local magnitude = math.sqrt(h^2 + v^2)
  if magnitude > 1.0 then magnitude = 1.0 end

  if not is_active then
    -- MODALITÀ 1: RIPOSO
    local beat = getHeartbeatIntensity(absolute_time)
    local min_brightness = 0.05 
    local dim_factor = min_brightness + (beat * 0.95)
    
    local r = math.floor(rgb_theme_r * dim_factor * p_heart_bright)
    local g = math.floor(rgb_theme_g * dim_factor * p_heart_bright)
    local b = math.floor(rgb_theme_b * dim_factor * p_heart_bright)
    
    for i = 0, 9 do
       setRGBLedColor(i + (ring_index * 10), r, g, b)
    end
    
  else
    -- MODALITÀ 2: MOVIMENTO
    local angle = math.atan2(v, h)
    angle = (math.deg(angle) + 360) % 360
    local center_index = math.floor(angle / 36 + 0.5) % 10

    for i = 0, 9 do
      local dist = math.abs(center_index - i)
      if dist > 5 then dist = 10 - dist end
      
      local wave_input = phase + (dist / 1.5)
      local wave = (math.sin(wave_input) + 1) / 2
      wave = wave * wave * wave * wave 
      local larsen_intensity = wave * (0.2 + (0.8 * (1.0 - magnitude)))

      local ptr_intensity = 0
      if dist <= 1.5 then 
          local proximity = 1.0 - (dist / 2.5) 
          if proximity < 0 then proximity = 0 end
          ptr_intensity = magnitude * proximity
          if dist == 0 then ptr_intensity = ptr_intensity * 1.3 end
      end
      
      local mask_larsen = 1.0 - (ptr_intensity * 1.5)
      if mask_larsen < 0 then mask_larsen = 0 end
      
      local r = (rgb_theme_r * larsen_intensity * mask_larsen) + (rgb_ptr_r * ptr_intensity)
      local g = (rgb_theme_g * larsen_intensity * mask_larsen) + (rgb_ptr_g * ptr_intensity)
      local b = (rgb_theme_b * larsen_intensity * mask_larsen) + (rgb_ptr_b * ptr_intensity)

      local effective_bright = p_heart_bright
      if ptr_intensity > larsen_intensity then effective_bright = p_ptr_bright end

      r = math.min(255, math.floor(r * effective_bright))
      g = math.min(255, math.floor(g * effective_bright))
      b = math.min(255, math.floor(b * effective_bright))
      
      setRGBLedColor(i + (ring_index * 10), r, g, b)
    end
  end
end

local function applyAxisLock(h, v)
    if math.abs(v) > 0.5 and math.abs(h) < AXIS_LOCK then h = 0 end
    if math.abs(h) > 0.5 and math.abs(v) < AXIS_LOCK then v = 0 end
    return h, v
end

local function run()
  local now = getTime() / 100
  local dt = now - last_time
  last_time = now

  -- ==========================================
  -- 1. GESTIONE DOPPIO CLICK (SF)
  -- ==========================================
  local sw_val = getValue(SRC_MENU_TRIGGER)
  
  if sw_val > 0 and last_sw_val <= 0 then
      if (now - last_click_time) < 0.8 then 
          click_count = click_count + 1
      else
          click_count = 1
      end
      last_click_time = now
  end
  last_sw_val = sw_val

  -- Azione al cambio menu
  if click_count >= 2 then
      menu_level = menu_level + 1
      if menu_level > 3 then menu_level = 0 end
      
      click_count = 0 
      
      -- BLOCCO POTENZIOMETRI (Safety Lock)
      -- Memorizza la posizione attuale e blocca l'input finché non viene mosso
      s1_lock_pos = getValue(SRC_POT_1)
      s2_lock_pos = getValue(SRC_POT_2)
      s1_locked = true
      s2_locked = true
      
      -- Feedback Visivo
      if menu_level == 0 then
          triggerFlash(1, 0, 255, 0, now) -- VERDE
      elseif menu_level == 1 then
          triggerFlash(1, 255, 255, 255, now) -- BIANCO x1
      elseif menu_level == 2 then
          triggerFlash(2, 255, 255, 255, now) -- BIANCO x2
      elseif menu_level == 3 then
          triggerFlash(3, 255, 255, 255, now) -- BIANCO x3
      end
  end

  -- ==========================================
  -- 2. GESTIONE FLASH
  -- ==========================================
  if flash_active then
      if now >= flash_next_toggle then
          flash_pattern_count = flash_pattern_count - 1
          if flash_pattern_count < 0 then
              flash_active = false 
          else
              flash_state_on = not flash_state_on
              flash_next_toggle = now + 0.15 
          end
      end
  end

  -- ==========================================
  -- 3. LETTURA POTENZIOMETRI & ASSEGNAZIONE
  -- ==========================================
  local raw_s1 = getValue(SRC_POT_1)
  local raw_s2 = getValue(SRC_POT_2)

  -- Controllo Sblocco S1
  if s1_locked then
      if math.abs(raw_s1 - s1_lock_pos) > LOCK_TOLERANCE then
          s1_locked = false -- Sbloccato! Utente ha mosso la manopola
      end
  end

  -- Controllo Sblocco S2
  if s2_locked then
      if math.abs(raw_s2 - s2_lock_pos) > LOCK_TOLERANCE then
          s2_locked = false -- Sbloccato!
      end
  end

  if menu_level == 0 then
      -- LIV 0: Nessuna azione (Pass-through)
      
  elseif menu_level == 1 then
      -- LIV 1: COLORI
      -- Aggiorna solo se sbloccato
      if not s1_locked then p_theme_hue = mapRange(raw_s1, 0.0, 1.0) end
      if not s2_locked then p_ptr_hue   = mapRange(raw_s2, 0.0, 1.0) end
      
  elseif menu_level == 2 then
      -- LIV 2: LUMINOSITÀ
      if not s1_locked then p_heart_bright = mapRange(raw_s1, 0.0, 1.0) end
      if not s2_locked then p_ptr_bright   = mapRange(raw_s2, 0.0, 1.0) end
      
  elseif menu_level == 3 then
      -- LIV 3: TEMPO (BPM & Pausa)
      if not s1_locked then p_bpm = mapRange(raw_s1, 15, 160) end
      if not s2_locked then p_pause_ratio = mapRange(raw_s2, 0.0, 2.0) end
  end

  -- ==========================================
  -- 4. CALCOLI FINALI (Colore & Fisica)
  -- ==========================================
  
  rgb_theme_r, rgb_theme_g, rgb_theme_b = hsvToRgb(p_theme_hue, 1, 1)
  rgb_ptr_r, rgb_ptr_g, rgb_ptr_b       = hsvToRgb(p_ptr_hue, 1, 1)

  local raw_ail = getValue("ail") / 1024
  local raw_ele = getValue("ele") / 1024
  local raw_thr = getValue("thr") / 1024
  local raw_rud = getValue("rud") / 1024

  if INV_ALETTONI then raw_ail = -raw_ail end
  if INV_PICCHIA  then raw_ele = -raw_ele end
  if INV_GAS      then raw_thr = -raw_thr end
  if INV_TIMONE   then raw_rud = -raw_rud end

  local phys_left_h = applyAxisLock(raw_rud, 0)
  local phys_left_v = raw_thr 
  local phys_right_h = raw_ail
  local phys_right_v = raw_ele
  
  phys_left_h, phys_left_v = applyAxisLock(raw_rud, raw_thr)
  phys_right_h, phys_right_v = applyAxisLock(raw_ail, raw_ele)

  local mag_L = math.sqrt(phys_left_h^2 + phys_left_v^2)
  local mag_R = math.sqrt(phys_right_h^2 + phys_right_v^2)
  if mag_L > 1 then mag_L = 1 end
  if mag_R > 1 then mag_R = 1 end

  is_active_left = updateHysteresisState(is_active_left, mag_L)
  is_active_right = updateHysteresisState(is_active_right, mag_R)

  local speed_coeff = MAX_VELOCITA * 6.28

  local speed_L = 0
  local speed_R = 0
  
  if is_active_left then speed_L = mag_L * speed_coeff end
  if is_active_right then speed_R = mag_R * speed_coeff end

  phase_left = phase_left + (speed_L * dt)
  phase_right = phase_right + (speed_R * dt)
  
  if phase_left > 1000 then phase_left = phase_left - 628 end
  if phase_right > 1000 then phase_right = phase_right - 628 end

  local idx_L, idx_R
  if SCAMBIA_ANELLI then idx_L = 1; idx_R = 0 else idx_L = 0; idx_R = 1 end

  drawRing(idx_L, phys_left_h, phys_left_v, phase_left, now, is_active_left)
  drawRing(idx_R, phys_right_h, phys_right_v, phase_right, now, is_active_right)
  
  applyRGBLedColors()
end

local function background() end
local function init() end
return { run=run, background=background, init=init }
