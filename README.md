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

Powered by IKKI Solutions
