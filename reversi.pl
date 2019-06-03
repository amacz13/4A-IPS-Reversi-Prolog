/* Base statique reversi */

grilleDepart([[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,x,o,-,-,-],[-,-,-,o,x,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-],[-,-,-,-,-,-,-,-]]).
pion(x).
pion(o).
campAdv(x,o).
campAdv(o,x).
vide(-).

succCol(a,b).
succCol(b,c).
succCol(c,d).
succCol(d,f).
succCol(e,f).
succCol(f,g).
succCol(g,h).

succLigne(1,2).
succLigne(2,3).
succLigne(3,4).
succLigne(4,5).
succLigne(5,6).
succLigne(6,7).
succLigne(7,8).

/* Affichage Ligne */

afficheLigne([A,B,C,D,E,F,G,H]):- write(A),write("|"),write(B),write("|"),write(C),write("|"),write(D),write("|"),write(E),write("|"),write(F),write("|"),write(G),write("|"),write(H).
afficheGrille([L1,L2,L3,L4,L5,L6,L7,L8]):- nl, afficheLigne(L1), nl, afficheLigne(L2), nl, afficheLigne(L3), nl, afficheLigne(L4), nl, afficheLigne(L5), nl, afficheLigne(L6), nl, afficheLigne(L7), nl, afficheLigne(L8), nl.

/* saisie coup */

saisieUnCoup(COL,LIG):- nl, write("Saisir colonne : "), nl, read(COL), nl, write("Saisir ligne : "), nl, read(LIG).

/* fonctions de base */
coordoneesOuListe(C,L,[C,L]).

/* Récupération d'une case dans une ligne */
caseDeLigne(a, [Case|_], Case).
caseDeLigne(NCol, [X|Ligne], Case):-
    succCol(NColSuiv,NCol),
    caseDeLigne(NColSuiv,Ligne,Case).

/* Récupération d'une ligne dans une grille */
ligneDeGrille(1, [Ligne|Grille], Ligne).
ligneDeGrille(NLigne, [X|Grille], Ligne):-
    succLigne(NLigneSuiv,NLigne),
    ligneDeGrille(NLigneSuiv,Grille,Ligne).

/* Récupération d'une case dans une grille */
caseDeGrille(NCol,NLigne,Grille,Case):-
    ligneDeGrille(NLigne, Grille, Ligne),
    caseDeLigne(NCol, Ligne, Case).

/* Liste Cases Jouables */

listeCasesJouables(GRILLE,[],[]).
listeCasesJouables(CAMP, GRILLE,[T|Q],LISTE):- listeCasesJouables(GRILLE,Q,LISTE), coordoneesOuListe(C,L,T),
    caseDeGrille(C,L,GRILLE,CASE), CASE = -, coupValide(GRILLE,T,CAMP), LISTE = [LISTE|CASE].

/* Trucs bizarres de Boubou */
/* Still in dev
coupValide(Grille, Coord, Camp):-
    coordonneesOuListe(Ncol, NLigne, Coord),
    caseDeGrille(NCol, NLigne, Grille, CaseCoup), vide(CaseCoup),
    succCol(Ncol, NcolSuiv).*/

/* Vérifie qu'il y a un changement */
changementPion(Ligne, Camp).