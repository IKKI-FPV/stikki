# STIKKIS by IKKI Solutions
### Advanced RGB LED Controller for EdgeTX / OpenTX

> **"IKKI Solutions è nata per creare soluzioni. Con STIKKIS, crediamo di esserci riusciti ancora una volta."**
>
> **"IKKI Solutions was born to create solutions. With STIKKIS, we believe we've succeeded once again."**

---

## 🇮🇹 ITALIANO

### Il Problema & La Soluzione
Chi usa script LUA per i LED conosce bene il problema: **"Script Syntax Error"** o **"CPU Limit Reached"**. 
Le radio non hanno abbastanza memoria per gestire menu complessi, salvataggi e animazioni fluide contemporaneamente nello stesso file.

**STIKKIS risolve il problema alla radice separando i compiti:**
1.  **Il Configuratore (`stikkis.lua`):** Lo usi solo a terra. Gestisce l'interfaccia, i colori e le impostazioni.
2.  **Il Generatore:** Quando salvi, STIKKIS **scrive un nuovo file ottimizzato** (es. `IKKI_1.lua`) che contiene *solo* la matematica necessaria per il volo.

**Risultato:** Configurazioni complesse a terra, leggerezza assoluta in volo. Nessun compromesso.

### Installazione
1.  Copia il file `stikkis.lua` nella cartella `/SCRIPTS/` della SD (o nella cartella che preferisci per lanciarlo).
2.  **IMPORTANTE:** Crea una cartella chiamata `RGBLED` dentro `/SCRIPTS/`.
    * Percorso: `/SCRIPTS/RGBLED/`
    * *Senza questa cartella, lo script non può generare i file di volo.*

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

---

## 🇬🇧 ENGLISH

### The Problem & The Solution
LED scripts often cause **Memory Errors** or **Latency** because they try to do too much (UI, saving, animations) in a single file.

**STIKKIS solves this by separating the workflow:**
1.  **The Configurator (`stikkis.lua`):** Used only on the ground for setup.
2.  **The Generator:** When you save, it **writes a brand new, optimized file** (e.g., `IKKI_1.lua`) containing *only* the flight code.

**Result:** Advanced features on the ground, zero overhead in the air.

### Installation
1.  Copy `stikkis.lua` to your SD Card's `/SCRIPTS/` folder.
2.  **CRITICAL:** Create a folder named `RGBLED` inside `/SCRIPTS/`.
    * Path: `/SCRIPTS/RGBLED/`
    * *The script needs this folder to save the generated files.*

### Radio Setup (Mixes)
Configure **Channel 14** with a 6-position switch to change themes.

**Copy these Mixer values exactly:**
![Mixer Settings](image_sw.jpg)

* Pos 1: -100% (Comet)
* Pos 2: -60%  (Rainbow)
* Pos 3: -20%  (Strobe)
* Pos 4: +20%  (Scanner)
* Pos 5: +60%  (Blink)
* Pos 6: +100% (Sparkles)

### Quick Start
Run `stikkis.lua`.
* **SF (Double Click):** Next Menu Page.
* **S1 / S2:** Adjust parameters.
* **Menu 0 (GREEN FLASH):** Save & Generate File.

---
*Powered by IKKI Solutions*
