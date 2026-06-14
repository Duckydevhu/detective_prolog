/* ==============================================================================
   PROLOG DETEKTÍV JÁTÉK - OKTATÁSI VERZIÓ
   Ez a program bemutatja a deklaratív programozás alapjait: tényeket (facts), 
   szabályok logikai levezetését (rules), beépített keresést (backtracking), 
   valamint a futásidejű memória-manipulációt (dynamic predicates).
============================================================================== */


% ==========================================
% KÖNYVTÁRAK ÉS MEMÓRIA BEÁLLÍTÁSA
% ==========================================

% DIRECTIVES (Direktívák): A ':-' jellel kezdődő sorok nem tények és nem is kérdések, 
% hanem utasítások a Prolog fordítónak (compiler).

% Betöltjük a 'random' (véletlenszám-generáló) beépített könyvtárat. 
% Erre azért van szükség, mert a tiszta logikában nincs "véletlen", ezt külön kell hívni.
:- use_module(library(random)).

% DINAMIKUS PREDIKÁTUMOK (Dynamic Predicates):
% A Prolog alapból "kőbe vésett" tudásbázissal dolgozik, a kód futás közben nem változhat.
% A 'dynamic' utasítással megengedjük a gépnek, hogy bizonyos tényeket játék közben 
% elfelejtsen (retract) vagy megtanuljon (assert).
% A '/3' és '/1' a paraméterek (argumentumok) számát jelenti (Ezt hívják Aritásnak - Arity).
:- dynamic igazsag/3.         % igazsag(Gyilkos, Fegyver, Helyszin) -> 3 adat
:- dynamic tipp_szamlalo/1.   % tipp_szamlalo(Szam) -> 1 adat
:- dynamic elmondott_nyom/1.  % elmondott_nyom(Nyom) -> 1 adat


% ==========================================
% 1. A VILÁG TÉNYEI (KNOWLEDGE BASE / FACTS)
% ==========================================
% A tények az univerzumunk megkérdőjelezhetetlen igazságai.
% FONTOS SZABÁLY: Minden, ami KISBETŰVEL kezdődik, az egy ATOM (konkrét, fix dolog/név).
% A Prolog nem ismeri a szavak jelentését, neki a 'mustar_ezredes' csak egy azonosító.

% --- GYANÚSÍTOTTAK ---
szemely(mustar_ezredes).
szemely(peacock_nover).
szemely(green_tiszteletes).
szemely(plum_professzor).

% --- FEGYVEREK ---
fegyver(pisztoly).
fegyver(tor).
fegyver(kotel).
fegyver(mereg).

% --- HELYSZÍNEK ---
helyszin(konyvtar).
helyszin(konyha).
helyszin(ebedlo).
helyszin(dolgozoszoba).

% --- TULAJDONSÁGOK (Tulajdonság hozzárendelése az atomokhoz) ---
ferfi(mustar_ezredes).
ferfi(green_tiszteletes).
ferfi(plum_professzor).

no(peacock_nover).


% ==========================================
% 2. LOGIKAI SZABÁLYOK (RULES)
% ==========================================
% A szabályok írják le az összefüggéseket a tények között.
% FONTOS SZABÁLY: Minden, ami NAGYBETŰVEL kezdődik, az egy VÁLTOZÓ (Variable).
% A Prolog a változók helyére próbál meg behelyettesíteni Atomokat a tényekből.

% SZABÁLY OLVASÁSA: "Egy eset (Gyilkos, Fegyver, Helyszin) akkor ÉRVÉNYES (:-), 
% HA a Gyilkos egy létező személy, ÉS (,) a Fegyver egy létező fegyver, ÉS a Helyszín..."
ervenyes_eset(Gyilkos, Fegyver, Helyszin) :-
    szemely(Gyilkos),
    fegyver(Fegyver),
    helyszin(Helyszin).

% --- A GÉP NYOMOZÁSA (Dedukciós példa) ---
% Ha a konzolba beírjuk: megoldas_1(K, M, H). a Prolog visszalépéses kereséssel 
% (backtracking) addig pörgeti a változókat, amíg minden feltétel IGAZ nem lesz.
megoldas_1(Gyilkos, Fegyver, Helyszin) :-
    ervenyes_eset(Gyilkos, Fegyver, Helyszin), % Behívjuk az alapfeltételt
    ferfi(Gyilkos),                            % 1. Nyom: A Gyilkos változóra igaz kell legyen a ferfi() tény.
    Gyilkos \= green_tiszteletes,              % 2. Nyom: A '\=' jelentése: NEM EGYENLŐ (Unification fails).
    Helyszin \= konyha,                        % 3. Nyom: Kizárjuk a konyhát.
    Fegyver = kotel,                           % 4. Nyom: A '=' jelentése unifikáció (hozzárendelés). A Fegyver a kötél.
    Helyszin = dolgozoszoba,                   % 5. Nyom: A Helyszín a dolgozószoba.
    Gyilkos \= plum_professzor.                % 6. Nyom: Kizárjuk Plum-ot.
    % Eredmény: A gép az összes férfi közül kizárta Green-t és Plum-ot, így maradt Mustár.


% ==========================================
% 3. INTERAKTÍV JÁTÉK (Te nyomozol)
% ==========================================

% --- ÚJ JÁTÉK INDÍTÁSA ---
% Ez egy 0 paraméteres (arity 0) szabály. Nincs benne változó, csak végrehajtódik.
uj_jatek :-
    % 1. MEMÓRIA TAKARÍTÁSA: A retractall() kitöröl mindent, ami illeszkedik a mintára.
    % Az '_' (alulvonás) az "Anonymus Variable" (Névtelen Változó). Jelentése: "Bármi lehet, nem érdekel a konkrét értéke".
    retractall(igazsag(_, _, _)),
    retractall(tipp_szamlalo(_)),
    retractall(elmondott_nyom(_)),
    
    % 2. SORSOLÁSOK (A listák és a random használata)
    % A 'findall(S, szemely(S), Szemelyek)' megkeresi az összes olyan S-t, amire igaz a szemely(S), 
    % és beleteszi őket a 'Szemelyek' nevű LISTÁBA (pl. [mustar_ezredes, peacock_nover...]).
    findall(S, szemely(S), Szemelyek), 
    % A random_member kivesz egy véletlenszerű elemet a listából, és beleteszi a 'Gyilkos' változóba.
    random_member(Gyilkos, Szemelyek),
    
    findall(F, fegyver(F), Fegyverek), random_member(Fegyver, Fegyverek),
    findall(H, helyszin(H), Helyszinek), random_member(Helyszin, Helyszinek),
    
    % 3. ÁLLAPOT MENTÉSE: Az 'assertz' (Assert-Z) a memóriába (a tudásbázis végére) írja az új tényeket.
    assertz(igazsag(Gyilkos, Fegyver, Helyszin)),
    assertz(tipp_szamlalo(0)),
    
    % 4. KIÍRATÁS: A 'write' kiírja a szöveget a képernyőre, az 'nl' (new line) sortörést csinál.
    write('==================================================='), nl,
    write(' UJJJJJJJJ BUNTENY TORTENT! '), nl,
    write(' A Prolog Jatekmester sorsolt egy tettest, egy '), nl,
    write(' fegyvert es egy helyszint. Keressuk a gyilkost! '), nl,
    write(' '), nl,
    write(' 1. Kerd a nyomokat igy: nyomok. (Egyesevel adja!)'), nl,
    write(' 2. Tippelj igy: tipp(Tettes, Fegyver, Helyszin). '), nl,
    write('==================================================='), nl.


% --- ÚJ, INTELLIGENS NYOMADÓ RENDSZER ---
nyomok :-
    % Lekérjük a dinamikus memóriából, mi a sorsolt igazság.
    igazsag(Gyilkos, Fegyver, Helyszin),
    
    % MÁGIA KÖVETKEZIK: A Prolog megnézi az összes létező 'lehetseges_nyom' szabályt,
    % behelyettesíti a Gyilkos, Fegyver, Helyszin adatokat, és ami IGAZ-zal tér vissza,
    % azt beleteszi az 'OsszesNyom' nevű listába.
    findall(Nyom, lehetseges_nyom(Gyilkos, Fegyver, Helyszin, Nyom), OsszesNyom),
    
    % ELÁGAZÁS (If-Then-Else) a Prologban: ( Feltétel -> IgazÁg ; HamisÁg ).
    % Ha az OsszesNyom egy üres lista ([])...
    ( OsszesNyom = [] ->
        write('--- NINCS TOBB NYOM, DETEKTIV! ---'), nl,
        write('Mar mindent elmondtam, amit tudtam. A tobbi a te dolgod!'), nl
    ; % Különben (ha van még nyom)...
        random_member(KivalasztottNyom, OsszesNyom), % Húzunk egyet a listából
        assertz(elmondott_nyom(KivalasztottNyom)),   % Megjegyezzük, hogy ezt már elmondtuk (nem mondjuk újra)
        kiir_nyom(KivalasztottNyom)                  % Meghívjuk a kiíró rutint
    ).

% --- A LEHETSÉGES NYOMOK DEFINÍCIÓI ---
% Mikor lehetséges egy nyom? 
% A '\+' operátor a "Negation as Failure" (Tagadás kudarccal). 
% Jelentése: A Prolog NEM TUDJA BIZONYÍTANI, hogy igaz. Jelen esetben: Még nincs a memóriában.

% 1. nyomtípus: A tettes neme. (Az első 3 paraméter mindegy (_), csak a 4. a lényeg)
lehetseges_nyom(_, _, _, neme) :- 
    \+ elmondott_nyom(neme).

% 2. nyomtípus: Egy fegyver kizárása.
lehetseges_nyom(_, ValodiFegyver, _, nem_fegyver(KizartFegyver)) :- 
    fegyver(KizartFegyver),                   % Veszünk egy létező fegyvert...
    KizartFegyver \= ValodiFegyver,           % ...ami NEM a valódi fegyver...
    \+ elmondott_nyom(nem_fegyver(KizartFegyver)). % ...és még nem zártuk ki korábban.

% 3. nyomtípus: Egy helyszín kizárása.
lehetseges_nyom(_, _, ValodiHelyszin, nem_helyszin(KizartHelyszin)) :- 
    helyszin(KizartHelyszin), 
    KizartHelyszin \= ValodiHelyszin, 
    \+ elmondott_nyom(nem_helyszin(KizartHelyszin)).

% 4. nyomtípus: Egy ártatlan személy alibije.
lehetseges_nyom(ValodiGyilkos, _, _, alibi(ArtatlanSzemely)) :- 
    szemely(ArtatlanSzemely), 
    ArtatlanSzemely \= ValodiGyilkos, 
    \+ elmondott_nyom(alibi(ArtatlanSzemely)).


% --- A SORSOLT NYOMOK SZÖVEGES KIÍRÁSA (Mintaillesztés - Pattern Matching) ---
% A Prolog aszerint választja ki, melyik 'kiir_nyom' blokkot futtatja le, 
% hogy a paraméter (pl. neme, vagy nem_fegyver(F)) melyikre illeszkedik!

kiir_nyom(neme) :-
    igazsag(Gyilkos, _, _), % Lekérjük a tettest
    write('--- UJ NYOM ---'), nl,
    % Ha a Gyilkos behelyettesíthető a ferfi() ténybe, akkor férfi, amúgy nő.
    (ferfi(Gyilkos) -> write('A szemtanuk szerint a tettes egy FERFI volt.') 
                     ; write('A szemtanuk szerint a tettes egy NO volt.')), nl.

kiir_nyom(nem_fegyver(F)) :-
    write('--- UJ NYOM ---'), nl,
    write('A laborvizsgalat kizarja, hogy a fegyver ez lett volna: '), write(F), nl.

kiir_nyom(nem_helyszin(H)) :-
    write('--- UJ NYOM ---'), nl,
    write('Biztosak vagyunk benne, hogy a buntett NEM itt tortent: '), write(H), nl.

kiir_nyom(alibi(S)) :-
    write('--- UJ NYOM ---'), nl,
    write('Neki bombabiztos alibije van (artatlan): '), write(S), nl.


% --- TIPPEZÉS ÉS SZÁMLÁLÓ ---
tipp(TippGyilkos, TippFegyver, TippHelyszin) :-
    igazsag(ValodiGyilkos, ValodiFegyver, ValodiHelyszin), % Megnézzük mi a sorsolt igazság
    
    % TIPPSZÁMLÁLÓ FRISSÍTÉSE:
    % A Prologban a változók nem változtathatók (Immutable). Ha X = 1, akkor X soha többé nem lehet 2.
    % Ezért le kell kérnünk a memóriából a régi számot, csinálni egy UjSzam-ot, a régit törölni, az újat menteni.
    tipp_szamlalo(Eddig),
    UjSzam is Eddig + 1,          % FIGYELEM: Matematikai művelethez az 'is' szót kell használni, nem az '=' jelet!
    retractall(tipp_szamlalo(_)), % Régi törlése
    assertz(tipp_szamlalo(UjSzam)), % Új érték eltárolása
    
    % TALÁLATOK ELLENŐRZÉSE:
    % Ha a tippel és a valóság unifikálható (megegyezik), a pont 1 lesz, amúgy 0.
    (TippGyilkos = ValodiGyilkos -> Pont1 = 1 ; Pont1 = 0),
    (TippFegyver = ValodiFegyver -> Pont2 = 1 ; Pont2 = 0),
    (TippHelyszin = ValodiHelyszin -> Pont3 = 1 ; Pont3 = 0),
    
    % Matematikai kiértékelés az 'is' operátorral
    Osszesen is Pont1 + Pont2 + Pont3,
    
    % ÉRTÉKELÉS ÉS VISSZAJELZÉS:
    % A '=:=' a numerikus egyenlőség vizsgálata (kiszámolja mindkét oldalt, és összeveti).
    ( Osszesen =:= 3 ->
        write('>>> ZSENIALIS VAGY DETEKTIV! <<<'), nl,
        write('Sikeresen megoldottad az esetet '), write(UjSzam), write(' tippbol!'), nl,
        write('Indithatsz egy uj_jatek.-ot!'), nl
    ;
        write('Nem tokeletes... Helyes elemek szama: '), write(Osszesen), write(' / 3'), nl,
        write('Ez volt a(z) '), write(UjSzam), write('. tipped.'), nl,
        write('Probald ujra, vagy kerj egy uj nyomot a nyomok. paranccsal!'), nl
    ).