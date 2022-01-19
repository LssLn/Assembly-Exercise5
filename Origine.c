int elabora(char *st, int d)
{ int i,conta;
conta=0;
for(i=0;i<d;i++)
if(st[i]<58) //if tutte lettere --> conta++
conta++;
return conta;
}
main() {
char STR[16];
int val;
do{
printf("Inserisci una stringa\n");
scanf("%s",STR);
val=elabora(ST,strlen(ST));
if(val!=0)
printf(" Valore= %d \n",val);
}
while (val!=0); //finisce quando il valore è 0 (tutte lettere)
}
