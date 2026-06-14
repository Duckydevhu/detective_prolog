🕵️‍♂️ Prolog Nyomozó (Prolog Detective)

Egy interaktív, logikai detektívjáték, amely a deklaratív programozás és a mesterséges intelligencia alapjait (backtracking, unifikáció, dinamikus predikátumok) mutatja be **Prolog** nyelven. Készült oktatási és demonstrációs céllal.

## 🌟 Funkciók

A projekt két fő részből áll:

1. **A Gép Nyomoz (Dedukció):** A Prolog egy sor előre megadott (és látszólag hiányos) nyom alapján, több ezer lehetséges kombinációt kizárva, a másodperc töredéke alatt levezeti a rejtély megoldását egyetlen algoritmus vagy `if/else` blokk megírása nélkül.
2. **Te Nyomozol (Interaktív Játék):** A "Játékmester" a háttérben véletlenszerűen sorsol egy gyilkost, egy fegyvert és egy helyszínt. A játékos célja, hogy nyomok kérésével és logikai dedukcióval ("Mastermind" stílusban) kitalálja az igazságot.

### 🧠 Intelligens Nyomadó Rendszer
A játék különlegessége a beépített okos-nyom rendszer:
* A gép sosem ismétli önmagát.
* Csak olyan nyomokat ad (pl. alibi, fegyver kizárása), amiket a korábbi körökben még nem fedett fel.
* Automatikusan számolja a próbálkozásokat.

## 🛠️ Telepítés és Előfeltételek

A futtatáshoz a legelterjedtebb Prolog környezetre lesz szükséged:

1. Töltsd le és telepítsd az [SWI-Prolog](https://www.swi-prolog.org/download/stable) rendszert.
   *(Fontos: Telepítésnél add hozzá a rendszered PATH változójához!)*
2. Ajánlott IDE: **Visual Studio Code**, a `Prolog` nevű kiegészítővel a megfelelő szintaxis-kiemeléshez.

## 🚀 Hogyan játssz?

1. Nyiss egy terminált a mappa gyökerében.
2. Indítsd el a Prolog interaktív parancssorát:
   bash:
   swipl
Töltsd be a projektfájlt (ne felejtsd el a pontot a végén!):

Prolog
[nyomozo].
(Megjegyzés: Ha módosítod a kódot, a make. paranccsal tudod újrafordítani.)

🎮 Játék parancsok
Új interaktív játék indítása:

Prolog
uj_jatek.
Egy nyom kikérése (bármennyiszer ismételhető, amíg van nyom):

Prolog
nyomok.
Tipp leadása (Cseréld ki a változókat a saját tippedre!):

Prolog
tipp(mustar_ezredes, tor, konyvtar).
A Gép dedukciós megoldásának lekérése (1-es Eset):

Prolog
megoldas_1(Ki, Mivel, Hol).
(Kilépés a Prolog terminálból: halt.)
