# STIKKIS by IKKI Solutions
### Advanced RGB LED Controller for EdgeTX / OpenTX

> **"IKKI Solutions è nata per creare soluzioni. Con STIKKIS, crediamo di esserci riusciti ancora una volta."**
>
> **"IKKI Solutions was born to create solutions. With STIKKIS, we believe we've succeeded once again."**

---

## 🇮🇹 ITALIANO

### Il Problema & La Soluzione
Chi usa script LUA per i LED sa benissimo che le opzioni sono davvero poche e gli effetti molto semplici.

**STIKKIS risolve il problema alla radice offrendo un sistema che permette di personalizzare gli script senza dover poi impegnare i canali o gli switch per tale scopo, separando i compiti:**
1.  **Il Configuratore (`stikkis.lua`):** Lo usi solo a banco. Gestisce l'interfaccia, i colori e le impostazioni.
2.  **Il Generatore:** Quando salvi, STIKKIS **scrive un nuovo file ottimizzato** (es. `IKKI_1.lua`) che contiene *solo* la matematica necessaria per l'effetto creato.

**Risultato:** Configurazioni complesse a terra, leggerezza assoluta durante il reale utilizzo. Nessun compromesso.

### Installazione
1.  Copia il file `stikkis.lua` nella cartella `/SCRIPTS/` della SD (o nella cartella che preferisci per lanciarlo).
2.  **IMPORTANTE:** Crea una cartella chiamata `RGBLED` dentro `/SCRIPTS/`.
    * Percorso: `/SCRIPTS/RGBLED/`
    * *Senza questa cartella, lo script non può generare i file di volo.*

### Configurazione Radio (Inputs)
Affinché i potenziometri S1 e S2 controllino i parametri degli effetti, è necessario attivarli nella pagina **INPUTS** del modello.

**Copia queste impostazioni:**
1. Vai nella pagina **INPUTS**.
2. Crea due nuovi ingressi (dopo i 4 stick principali).
3. **Input S1:** Imposta "Source" su **S1** e "Weight" su **100%**.
4. **Input S2:** Imposta "Source" su **S2** e "Weight" su **100%**.

![Lista Inputs](image_s1.jpg)
![Dettaglio Input S1](image_s2.jpg)

### Configurazione Radio (Mixer)
Per cambiare i 6 temi in volo, configura il **Canale 14** (o quello definito nello script) su uno switch a 6 posizioni.

**Copia esattamente questi valori nei Mixer:**
![Settaggi Mixer](image_sw.jpg)

* Pos 1: -100% (Cometa)
* Pos 2: -60%  (Arcobaleno)
* Pos 3: -20%  (Strobo)
* Pos 4: +20%  (Scanner)
* Pos 5: +60%  (Blink)
* Pos 6: +100% (Sparkles)

### Guida Rapida
Lancia lo script `stikkis.lua`.
* **SF (Doppio Click):** Cambia pagina menu (0-4).
* **S1 / S2:** Regolano i parametri.
* **Menu 0 (FLASH VERDE):** Salva e Genera il file.

4. STRUTTURA DEI LIVELLI DI REGOLAZIONE
---------------------------------------
Usa lo switch SF (Doppio Click) per navigare tra i livelli.
I LED lampeggeranno di BIANCO per indicare il livello corrente.

> LIVELLO 0 (FLASH VERDE): SALVATAGGIO
  Esce dal menu e genera automaticamente il file di volo "IKKI_x.lua".

> LIVELLO 1 (1 Flash): SELEZIONE TEMA
  Usa lo switch a 6 posizioni (CH14) per scegliere l'effetto da modificare.

> LIVELLO 2 (2 Flash): COLORE
  S1 (SX): Tonalita' Colore Tema (Sfondo)
  S2 (DX): Tonalita' Colore Puntatore (Stick)

> LIVELLO 3 (3 Flash): LUMINOSITA'
  S1 (SX): Luminosita' Tema
  S2 (DX): Luminosita' Puntatore

> LIVELLO 4 (4 Flash): DINAMICA & FISICA
  In questo livello, S1 e S2 cambiano funzione in base al tema scelto.
  Vedi la tabella sottostante.


5. GUIDA REGOLAZIONI LIVELLO 4 (DINAMICA)
-----------------------------------------

[ TEMA 1 ] COMETA
  - S1: Lunghezza Coda
  - S2: BPM Battito (Regola la velocita' del "cuore" di sfondo)

[ TEMA 2 ] ARCOBALENO
  - S1: Velocita' Rotazione
  - S2: Intensita' Battito (0 = Sfondo Fisso / >0 = Attiva Pulsazione)

[ TEMA 3 ] STROBO
  - S1: Frequenza Strobo
  - S2: Soglia Attivazione (Quanto stick serve per attivare l'effetto)

[ TEMA 4 ] SCANNER (Parentesi)
  - S1: Velocita' Scansione
  - S2: Larghezza Gap (Allarga lo spazio centrale tra le parentesi)

[ TEMA 5 ] BLINK (Alternato)
  - S1: BPM Lampeggio
  - S2: Riservato

[ TEMA 6 ] SPARKLES (Brillantini)
  - S1: Frequenza Scintillio (Velocita' luccichio)
  - S2: Curva Densita' (Quantita' di stelle basata sul Gas)

=========================================================================

---

🇬🇧 ENGLISH
The Problem & The Solution

Anyone using LUA scripts for LEDs knows very well that options are scarce and effects are very basic.

STIKKIS solves this problem at the root by offering a system that allows you to customize scripts without having to commit channels or switches for that purpose, by separating the tasks:

    The Configurator (stikkis.lua): Used only on the bench. It handles the interface, colors, and settings.

    The Generator: When you save, STIKKIS writes a new optimized file (e.g., IKKI_1.lua) containing only the mathematics needed for the RGB effect you just created.
    
Result: Complex configurations on the ground, absolute lightness during actual use. No compromises.
Installation

    Copy the stikkis.lua file to the /SCRIPTS/ folder on your SD card (or whichever folder you prefer to launch it from).

    IMPORTANT: Create a folder named RGBLED inside /SCRIPTS/.

        Path: /SCRIPTS/RGBLED/

        Without this folder, the script cannot generate flight files.

Radio Setup (Inputs)

For potentiometers S1 and S2 to control effect parameters, you must activate them in the model's INPUTS page.

Copy these settings:

    Go to the INPUTS page.

    Create two new inputs (after the 4 main sticks).

    Input S1: Set "Source" to S1 and "Weight" to 100%.

    Input S2: Set "Source" to S2 and "Weight" to 100%.

Radio Setup (Mixer)

To change the 6 themes in flight, configure Channel 14 (or the one defined in the script) to a 6-position switch.

Copy these exact values in the Mixer:

    Pos 1: -100% (Comet)

    Pos 2: -60% (Rainbow)

    Pos 3: -20% (Strobe)

    Pos 4: +20% (Scanner)

    Pos 5: +60% (Blink)

    Pos 6: +100% (Sparkles)

Quick Start

Run the script stikkis.lua.

    SF (Double Click): Change menu page (0-4).

    S1 / S2: Adjust parameters.

    Menu 0 (GREEN FLASH): Save and Generate file.

    4. MENU LEVELS STRUCTURE
------------------------
Use SF Switch (Double Click) to cycle levels. LEDs flash WHITE to indicate level.

> LEVEL 0 (GREEN FLASH): SAVE & EXIT
  Generates the optimized flight file "IKKI_x.lua".

> LEVEL 1 (1 Flash): THEME SELECTION
  Use the 6-pos switch (CH14) to select the effect to edit.

> LEVEL 2 (2 Flashes): COLOR
  S1 (Left): Theme Color (Background)
  S2 (Right): Pointer Color (Stick)

> LEVEL 3 (3 Flashes): BRIGHTNESS
  S1 (Left): Theme Brightness
  S2 (Right): Pointer Brightness

> LEVEL 4 (4 Flashes): DYNAMICS & PHYSICS
  S1 and S2 functions change based on the selected theme. See below.


5. LEVEL 4 ADJUSTMENT GUIDE
---------------------------

[ THEME 1 ] COMET
  - S1: Tail Length
  - S2: Heartbeat BPM (Background pulse speed)

[ THEME 2 ] RAINBOW
  - S1: Rotation Speed
  - S2: Heartbeat Depth (0 = Solid / >0 = Adds Pulsation)

[ THEME 3 ] STROBE
  - S1: Frequency
  - S2: Threshold (Stick input required to activate)

[ THEME 4 ] SCANNER (Brackets)
  - S1: Scan Speed
  - S2: Gap Width (Widens the center gap)

[ THEME 5 ] BLINK (Alternating)
  - S1: Blink BPM
  - S2: Reserved

[ THEME 6 ] SPARKLES
  - S1: Sparkle Freq. (Glitter speed)
  - S2: Density Curve (Amount vs Throttle)

=========================================================================

    

Powered by IKKI Solutions
