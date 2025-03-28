%{
#include <iostream>
#include <iomanip>
//#include <locale>
#include <string>
#include <vector>
#include <queue>
#include <stack>
#include <tuple>
#include <fstream>
#include "lexer.h"
#define A 0
#define B 1
#define C 2
#define D 3
#define ORDINARI 0
#define MUSICISTI 1
#define JUNIOR 2
#define SENIOR 3
#define DISABILI 4
#define AUTORITA 5

using namespace std;

void yyerror(const char *msg);
double calcoloVenditaTotaleBiglietto(const size_t categoriaBiglietto);

vector<double> prezziBiglietti(4);
vector<int> scontiBiglietti(6);
queue<int> codaOrdinari;
queue<int> codaMusicisti;
queue<int> codaJunior;
queue<int> codaSenior;
queue<int> codaDisabili;
queue<int> codaAutorita;
stack<tuple<string,string,string>> stackTappe;
%}

%union {
    int numero;
    double reale;
    std::string* stringa;
}

%token citta location dataTappa separatoreTappa 
%token ordinariA musicistiA juniorA seniorA disabiliA autoritaA
%token ordinariB musicistiB juniorB seniorB disabiliB autoritaB
%token ordinariC musicistiC juniorC seniorC disabiliC autoritaC
%token ordinariD musicistiD juniorD seniorD disabiliD autoritaD
%token prezzoA prezzoB prezzoC prezzoD
%token scontoA scontoO scontoM scontoS scontoJ scontoD

%type <stringa> citta location dataTappa
%type <numero> ordinariA musicistiA juniorA seniorA disabiliA autoritaA
%type <numero> ordinariB musicistiB juniorB seniorB disabiliB autoritaB
%type <numero> ordinariC musicistiC juniorC seniorC disabiliC autoritaC
%type <numero> ordinariD musicistiD juniorD seniorD disabiliD autoritaD
%type <reale> prezzoA prezzoB prezzoC prezzoD
%type <numero> scontoA scontoO scontoM scontoS scontoJ scontoD

%start input

%%

input: tappa prezzi sconti;

tappa: citta location dataTappa bigliettoA bigliettoB bigliettoC bigliettoD fine {
    tuple<string,string,string> tappa(*$1,*$2,*$3);
    stackTappe.push(tappa);
};

fine: separatoreTappa tappa | separatoreTappa;

bigliettoA: ordinariA musicistiA juniorA seniorA disabiliA autoritaA {
    codaOrdinari.push($1);
    codaMusicisti.push($2);
    codaJunior.push($3);
    codaSenior.push($4);
    codaDisabili.push($5);
    codaAutorita.push($6);
};
bigliettoB: ordinariB musicistiB juniorB seniorB disabiliB autoritaB {
    codaOrdinari.push($1);
    codaMusicisti.push($2);
    codaJunior.push($3);
    codaSenior.push($4);
    codaDisabili.push($5);
    codaAutorita.push($6);
};
bigliettoC: ordinariC musicistiC juniorC seniorC disabiliC autoritaC {
    codaOrdinari.push($1);
    codaMusicisti.push($2);
    codaJunior.push($3);
    codaSenior.push($4);
    codaDisabili.push($5);
    codaAutorita.push($6);
};
bigliettoD: ordinariD musicistiD juniorD seniorD disabiliD autoritaD {
    codaOrdinari.push($1);
    codaMusicisti.push($2);
    codaJunior.push($3);
    codaSenior.push($4);
    codaDisabili.push($5);
    codaAutorita.push($6);
};

prezzi: prezzoA prezzoB prezzoC prezzoD {
    prezziBiglietti.at(A)=$1;
    prezziBiglietti.at(B)=$2;
    prezziBiglietti.at(C)=$3;
    prezziBiglietti.at(D)=$4;
};
sconti: scontoO scontoM scontoJ scontoS scontoD scontoA {
    scontiBiglietti.at(ORDINARI) = $1;
    scontiBiglietti.at(MUSICISTI) = $2;
    scontiBiglietti.at(JUNIOR) = $3;
    scontiBiglietti.at(SENIOR) = $4;
    scontiBiglietti.at(DISABILI) = $5;
    scontiBiglietti.at(AUTORITA) = $6;
};

%%

int main(int argc, char *argv[]) {
    double totaleVendite = 0, totaleBenificienza = 0, venditaTotaleTappa, beneficienzaTotaleTappa;
    yyparse();
    ofstream file("output.txt");
    if(!file.is_open()){
        cerr<<"Non è stato possibile creare il file di output. Il risultato verrà mostrato a video"<<endl;
        auto file = stdout;
    }
    //std::locale::global(std::locale("en_GB.UTF-8"));
    //file.imbue(std::locale());
    file << fixed << setprecision(2);
    while(!stackTappe.empty()){
        venditaTotaleTappa = 0;
        beneficienzaTotaleTappa = 0;
        file << get<0>(stackTappe.top()) + " " + get<1>(stackTappe.top()) + " " + get<2>(stackTappe.top()) <<endl;
        venditaTotaleTappa += calcoloVenditaTotaleBiglietto(A);
        venditaTotaleTappa += calcoloVenditaTotaleBiglietto(B);
        venditaTotaleTappa += calcoloVenditaTotaleBiglietto(C);
        venditaTotaleTappa += calcoloVenditaTotaleBiglietto(D);
        file << "Vendita biglietti --> euro " << venditaTotaleTappa << endl;
        if(venditaTotaleTappa<=3700000)
            beneficienzaTotaleTappa = venditaTotaleTappa/100;
        else if (venditaTotaleTappa<=4500000)
            beneficienzaTotaleTappa = (venditaTotaleTappa*1.2)/100;
        else
            beneficienzaTotaleTappa = (venditaTotaleTappa*1.8)/100;
        file << "Benificienza --> euro " << beneficienzaTotaleTappa << endl;
        file << "---" << endl;
        totaleVendite += venditaTotaleTappa;
        totaleBenificienza += beneficienzaTotaleTappa;
        stackTappe.pop();
    }
    file << "%%%" << endl;
    file << "Totale vendita biglietti --> euro " << totaleVendite << endl;
    file << "Totale Benificienza --> euro " << totaleBenificienza << endl;
    file.close();

    return 0;
}

void yyerror(const char *msg) {
    std::cerr << "Errore di parsing: " << msg << std::endl;
    exit(EXIT_FAILURE);
}

double calcoloVenditaTotaleBiglietto(const size_t categoriaBiglietto) {
    int numeroBiglietti;
    double prezzoScontato = 0, venditaTotaleBiglietto = 0, prezzo = prezziBiglietti.at(categoriaBiglietto), sconto;
    //cout<<prezzo<<endl;
    numeroBiglietti = codaOrdinari.front();
    sconto = scontiBiglietti.at(ORDINARI);
    prezzoScontato = prezzo - (prezzo*sconto)/100;
    venditaTotaleBiglietto += prezzoScontato * numeroBiglietti;
    codaOrdinari.pop();

    numeroBiglietti = codaMusicisti.front();
    sconto = scontiBiglietti.at(MUSICISTI);
    prezzoScontato = prezzo - (prezzo*sconto)/100;
    venditaTotaleBiglietto += prezzoScontato * numeroBiglietti;
    codaMusicisti.pop();

    numeroBiglietti = codaJunior.front();
    sconto = scontiBiglietti.at(JUNIOR);
    prezzoScontato = prezzo - (prezzo*sconto)/100;
    venditaTotaleBiglietto += prezzoScontato * numeroBiglietti;
    codaJunior.pop();

    numeroBiglietti = codaSenior.front();
    sconto = scontiBiglietti.at(SENIOR);
    prezzoScontato = prezzo - (prezzo*sconto)/100;
    venditaTotaleBiglietto += prezzoScontato * numeroBiglietti;
    codaSenior.pop();

    numeroBiglietti = codaDisabili.front();
    sconto = scontiBiglietti.at(DISABILI);
    prezzoScontato = prezzo - (prezzo*sconto)/100;
    venditaTotaleBiglietto += prezzoScontato * numeroBiglietti;
    codaDisabili.pop();

    numeroBiglietti = codaAutorita.front();
    sconto = scontiBiglietti.at(AUTORITA);
    prezzoScontato = prezzo - (prezzo*sconto)/100;
    venditaTotaleBiglietto += prezzoScontato * numeroBiglietti;
    codaAutorita.pop();

    return venditaTotaleBiglietto;
}
