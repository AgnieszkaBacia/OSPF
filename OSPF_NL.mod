//Node-Link
//indeksy
int E = ...;
int V = ...;
int D = ...;
  
range e = 1..E;
range v = 1..V;
range d = 1..D;

//stale
int h[d] = ...;
int omega[e]=...;
int przeplywnosc = ...; //jest na wszystkich ³¹czach taka sama wiêc wziê³am jako zmienna
int s[d] = ...;
int t[d] = ...;
float a[e][v] = ...;
float b[e][v] = ...;
//do odczytywania
float suma[d] = ...;

//zmienne
dvar float+ x[e][d];
dvar float+ y[e];

//funkcja celu
minimize
  sum(i in e) omega[i] * y[i];
  
//ograniczenia
subject to {
// i - krawedzie; f - wezly, m - zapotrzebowania 
	forall(i in e){
		sum(j in d) x[i][j] == y[i];
		y[i] <= przeplywnosc;
	}		
	forall(f in v, m in d : f != s[m] && f != t[m] )
	  	sum(i in e) a[i][f] * x[i][m] - sum(i in e)b[i][f]*x[i][m] == 0;
	forall(f in v, m in d : f == s[m])
 		sum(i in e) a[i][f] * x[i][m] - sum(i in e)b[i][f]*x[i][m] == h[m];
 	forall(f in v, m in d : f == t[m])
 		sum(i in e) a[i][f] * x[i][m] - sum(i in e)b[i][f]*x[i][m] == -h[m];
}



 execute {
 	for(var i in d){
 		for (var m in e) {suma[i] = suma[i] + x[m][i]*omega[m];} 
 		
 		writeln("Koszt œcie¿ki ", i, " to: ", suma[i]); 	
 		write("Œcie¿ka dla zapotrzebowania ", i, " to: ");
 		for(var j in e){
 		 		if(x[j][i] > 0) write( j, " ");
 		}
	} 	
			
 }