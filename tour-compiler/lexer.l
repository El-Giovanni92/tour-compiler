%{
    #include <iostream>
    #include <string.h>
    #include "parser.hpp"
    using namespace std;
    char categoria;
%}
tipologieBiglietti [OMJSDA]
categorie [ABCD]
%option header-file="lexer.h"
%option noyywrap
%x statoBiglietto sezionePrezzi sezioneSconti
%%
"Città: "[A-Z']+([ ][A-Z']+)*";" {
    string* subStringa = new string(yytext);
    *subStringa = subStringa->substr(8,subStringa->length()-9);
    yylval.stringa = subStringa;
    return citta;
}
"Location: "[A-Z][a-z]*([ ][A-Z][a-z]*)*";" {
    string* subStringa = new string(yytext);
    *subStringa = subStringa->substr(10,subStringa->length()-11);
    yylval.stringa = subStringa;
    return location;
}
"Data: "[0-9]{2}"-"[0-9]{2}"-"[0-9]{4}";" {
    string* subStringa = new string(yytext);
    *subStringa = subStringa->substr(6,subStringa->length()-7);
    yylval.stringa = subStringa;
    return dataTappa;
}
"Biglietti cat. "[A-D]": (" {
    categoria = yytext[15];
    BEGIN(statoBiglietto);
}
"********************" {return separatoreTappa;}
"$$$" {BEGIN(sezionePrezzi);}
\n ;
. ;
<statoBiglietto>{tipologieBiglietti}":"[0-9]+ {
    string subStringa(yytext);
    char tipologia = subStringa.at(0);
    subStringa = subStringa.substr(2,subStringa.length()-2);
    switch (categoria){
        case 'A':
            switch (tipologia){
                case 'O':
                    yylval.numero=stoi(subStringa);
                    return ordinariA;
                    break;
                case 'M':
                    yylval.numero=stoi(subStringa);
                    return musicistiA;
                    break;
                case 'S':
                    yylval.numero=stoi(subStringa);
                    return seniorA;
                    break;
                case 'J':
                    yylval.numero=stoi(subStringa);
                    return juniorA;
                    break;
                case 'D':
                    yylval.numero=stoi(subStringa);
                    return disabiliA;
                    break;
                case 'A':
                    yylval.numero=stoi(subStringa);
                    return autoritaA;
                    break;
            }
            break;
        
        case 'B':
            switch (tipologia){
                case 'O':
                    yylval.numero = stoi(subStringa);
                    return ordinariB;
                    break;
                case 'M':    
                    yylval.numero = stoi(subStringa);
                    return musicistiB;
                    break;
                case 'S':
                    yylval.numero = stoi(subStringa);
                    return seniorB;
                    break;
                case 'J':
                    yylval.numero = stoi(subStringa);
                    return juniorB;
                    break;
                case 'D':
                    yylval.numero = stoi(subStringa);
                    return disabiliB;
                    break;
                case 'A':
                    yylval.numero = stoi(subStringa);
                    return autoritaB;
                    break;
            }
            break;
            
        case 'C':
            switch (tipologia){
                case 'O':
                    yylval.numero=stoi(subStringa);
                    return ordinariC;
                case 'M':
                    yylval.numero=stoi(subStringa);
                    return musicistiC;
                    break;
                case 'S':
                    yylval.numero=stoi(subStringa);
                    return seniorC;
                    break;
                case 'J':
                    yylval.numero=stoi(subStringa);
                    return juniorC;
                    break;
                case 'D':
                    yylval.numero=stoi(subStringa);
                    return disabiliC;
                    break;
                case 'A':
                    yylval.numero=stoi(subStringa);
                    return autoritaC;
                    break;
            }
            break;

        case 'D':
            switch (tipologia){
                case 'O':
                    yylval.numero=stoi(subStringa);
                    return ordinariD;
                    break;
                case 'M':
                    yylval.numero=stoi(subStringa);
                    return musicistiD;
                    break;
                case 'S':
                    yylval.numero=stoi(subStringa);
                    return seniorD;
                    break;
                case 'J':
                    yylval.numero=stoi(subStringa);
                    return juniorD;
                    break;
                case 'D':
                    yylval.numero=stoi(subStringa);
                    return disabiliD;
                    break;
                case 'A':
                    yylval.numero=stoi(subStringa);
                    return autoritaD;
                    break;
            }
            break;
    }
}
<statoBiglietto>")" {std::cout<<std::endl; BEGIN(INITIAL);}
<statoBiglietto>. ;
<sezionePrezzi>"Prezzo"{categorie}" --> "[0-9]+([\.][0-9]{2})?" EURO." {
    string subStringa(yytext);
    char prezzoCategoria = subStringa.at(6);
    subStringa = subStringa.substr(12,subStringa.length()-18);
    switch (prezzoCategoria){
        case 'A':
            yylval.reale = stod(subStringa);
            return prezzoA;
            break;
        case 'B':
            yylval.reale = stod(subStringa);
            return prezzoB;
            break;
        case 'C':
            yylval.reale = stod(subStringa);
            return prezzoC;
            break;
        case 'D':
            yylval.reale = stod(subStringa);
            return prezzoD;
            break;   
    }
}
<sezionePrezzi>"++++++++++++++++++++" {BEGIN(sezioneSconti);}
<sezionePrezzi>\n ;
<sezionePrezzi>. ;
<sezioneSconti>("Junior: "|"Senior: ")[0-9]{1,3} {
                    string subStringa(yytext);
                    string tipologia = subStringa.substr(0,6);                 
                    subStringa = subStringa.substr(8,subStringa.length()-8);
                    yylval.numero=stoi(subStringa);
                    if(tipologia == "Junior"){
                        return scontoJ;
                    }
                    else{
                        return scontoS;
                    }
}

<sezioneSconti>("Disabili: "|"Ordinari: ")[0-9]{1,3} {
                    string subStringa(yytext);
                    string tipologia = subStringa.substr(0,8);  
                    subStringa = subStringa.substr(10,subStringa.length()-10);
                    yylval.numero = stoi(subStringa);
                    if(tipologia == "Disabili"){
                        return scontoD;
                    }
                    else{
                        return scontoO;
                    }
}

<sezioneSconti>("Musicisti: "|"Autorità: ")[0-9]{1,3} {
                    string subStringa(yytext);
                    string tipologia = subStringa.substr(0,9); 
                    subStringa = subStringa.substr(11,subStringa.length()-11);
                    yylval.numero=stoi(subStringa);
                    if(tipologia == "Musicisti"){
                        return scontoM;
                    }
                    else{
                        return scontoA;
                    }
}
<sezioneSconti>\n ;
<sezioneSconti>. ;
%%
