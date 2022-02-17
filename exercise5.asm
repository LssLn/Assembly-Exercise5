.data 
ST: .space 16
stack: .space 32

msg1: .asciiz "Inserire stringa \n"
msg2: .asciiz "Valore : %d\n" ;# con val 1° arg msg2

p1sys5: .space 8
val: .space 8 ;# val, int aka 1° arg msg2

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;# numbyte da leggere, <= ST 

.code 
;# inizializzazione stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;# i=0
do: ;# while val!=0, ma prima devo inserirlo. Non metto come sempre le condizioni slti e beq, ci penso dopo aver preso val

    ;#printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf %s, ST
    daddi $t0, $0, ST
    sd $t0, ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;# passaggio parametri
    move $a1,r1         ;# $a1 = strlen(ST)
    daddi $a0,$0,ST     ;# $a0 = ST

    jal elabora
    sd r1, val($0)  ;# return in val, 1° arg msg2
    dadd $s4,$0,r1 ;# $s4 = val
    ;# if(Val!=0) printf msg2
    ;#ld $t0,val($0) ;# $t0 = val ;# uso invece $s4
    beq $s4,$0, exit ;# se val== 0 esco dal programma. Se no continuo
    ;#printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5 ;# alla fine prosegue con il do

    j do    ;# se no continua e salta a do

elabora: ;# $a0 = ST, $a1 = strlen
    daddi $sp,$sp,-16 ;#i e conta
    sd $s1,0($sp)   ;# i
    sd $s2,8($sp)   ;# conta
    daddi $s1,$0,0 ;# i=0
    daddi $s2,$0,0 ;#conta=0

for:
    slt $t0,$s1,$a1 ;# $t0=0 quando $s1>=$a1, ovvero i >= strlen(=d)
    beq $t0,$0,fine_for ;# fine for quando i>=strlen, ossia $t0=0
    
    ;# if(st[i]<58)
    dadd $t0,$a0,$s1 ;# $t0 = &st[i] = st ($a0) + i ($s1)
    lbu $t1,0($t0)  ;# $t1 = st[i]

    slti $t0,$t1,58 ;# $t0 = 0 quando $t1 (st[i]) >= 58
    beq $t0,$0, falso ;# salta l'incremento di conta, scorre for
    daddi $s2,$s2,1 ;#conta ++ se $t0 !== 0, ovvero st[i] < 58 (numeri), poi va a falso
falso: 
    daddi $s1,$s1,1 ;# i++
    j for
fine_for:
    move r1,$s2 ;# r1 = $s2 = conta
    ld $s1,0($sp)
    ld $s2,8($sp)
    daddi $sp,$sp,16
    jr $ra


exit:
    syscall 0

