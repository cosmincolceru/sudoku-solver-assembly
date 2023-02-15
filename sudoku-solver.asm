.data
	f: .space 4
	g: .space 4
	numar: .space 4
	sudoku: .space 400
	elem: .space 4
	x: .space 4
	y: .space 4
	n: .space 4
	xs: .space 4
	ys: .space 4
	lin: .space 4
	col: .space 4
	maxim: .long 9
	trei: .long 3
	fisierIn: .asciz "sudoku.txt"
	fisierIesire: .asciz "sudoku_rezolvat.txt"
	mesaj: .asciz "nu exista solutie\n"
	read: .asciz "r"
	write: .asciz "w"
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	newline: .asciz "\n"
.text

.global main

verifLinie:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %eax
	movl %eax, x
	movl 12(%ebp), %eax
	movl %eax, n
	
	pushl %edi
	movl $sudoku, %edi
	//for (%ecx = 0; %ecx < 9; %ecx++)
	xorl %ecx, %ecx
for_l:
	cmp maxim, %ecx
	je verifLinie_ok
	
	//%edx = x * maxim + %ecx
	xorl %edx, %edx
	movl x, %eax
	mull maxim
	movl %eax, %edx
	addl %ecx, %edx
	
	//if (sudoku[x][%ecx] == n) return 0;
	movl n, %eax
	cmp (%edi, %edx, 4), %eax
	je verifLinie_not_ok
	
	incl %ecx
	jmp for_l
	
verifLinie_not_ok:
	movl $0, %eax
	jmp verifLinie_exit
	
verifLinie_ok:
	movl $1, %eax
	jmp verifLinie_exit

verifLinie_exit:
	popl %edi
	popl %ebp
	ret


verifColoana:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %eax
	movl %eax, y
	movl 12(%ebp), %eax
	movl %eax, n
	
	pushl %edi
	
	movl $sudoku, %edi
	xorl %ecx, %ecx
for_c:
	cmp %ecx, maxim
	je verifColoana_ok
	
	//%edx = %ecx * maxim + y
	xorl %edx, %edx	
	movl %ecx, %eax
	mull maxim
	movl %eax, %edx
	addl y, %edx
	
	movl n, %eax
	cmp (%edi, %edx, 4), %eax
	je verifColoana_not_ok
	
	incl %ecx
	jmp for_c

verifColoana_not_ok:
	movl $0, %eax
	jmp verifColoana_exit

verifColoana_ok:
	movl $1, %eax
	jmp verifColoana_exit
	
verifColoana_exit:
	popl %edi
	popl %ebp
	ret


verifPatrat:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %eax
	movl %eax, x
	movl 12(%ebp), %eax
	movl %eax, y
	movl 16(%ebp), %eax
	movl %eax, n
	
	//xs = x / 3 * 3
	xorl %edx, %edx
	movl x, %eax	
	divl trei
	xorl %edx, %edx
	mull trei
	movl %eax, xs
	
	//ys = y / 3 * 3
	xorl %edx, %edx
	movl y, %eax
	divl trei
	xorl %edx, %edx
	mull trei
	movl %eax, ys
	
	pushl %ebx
	pushl %edi
	
	movl $sudoku, %edi
	
	movl xs, %ecx
	addl $3, xs
for_xs:
	cmp xs, %ecx
	je verifPatrat_ok
	
	movl ys, %ebx
	addl $3, ys
for_ys:
	cmp ys, %ebx
	je cont_for_xs

	//%edx = %ecx * maxim + %ebx
	xorl %edx, %edx
	movl %ecx, %eax
	mull maxim
	movl %eax, %edx
	addl %ebx, %edx
	
	movl n, %eax
	cmp (%edi, %edx, 4), %eax
	je verifPatrat_not_ok

	incl %ebx
	jmp for_ys

cont_for_xs:
	subl $3, ys
	
	incl %ecx
	jmp for_xs
	
verifPatrat_not_ok:
	movl $0, %eax
	jmp verifPatrat_exit
	
verifPatrat_ok:
	movl $1, %eax
	jmp verifPatrat_exit
	
verifPatrat_exit:
	popl %edi
	popl %ebx
	popl %ebp
	ret


isOk:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %eax
	movl %eax, x
	movl 12(%ebp), %eax
	movl %eax, y
	movl 16(%ebp), %eax
	movl %eax, n
	
	pushl n
	pushl x
	call verifLinie
	popl x
	popl n
	
	cmp $0, %eax
	je isOk_nu
	
	pushl n
	pushl y
	call verifColoana
	popl y
	popl n
	
	cmp $0, %eax
	je isOk_nu
	
	pushl n
	pushl y
	pushl x
	call verifPatrat
	popl x
	popl y
	popl n
	
	cmp $0, %eax
	je isOk_nu
	
	movl $1, %eax
	jmp isOk_exit

isOk_nu:
	movl $0, %eax

isOk_exit:
	popl %ebp
	ret


rezolva:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %eax    #eax = lin
	movl 12(%ebp), %edx   #edx = col
	
	pushl %edi
	
	movl %eax, lin
	movl %edx, col
	
	//if (lin == 9) return 1;
	cmp $9, lin
	je return_1
		
	movl $sudoku, %edi
	//%eax = lin * 9 + col
	xorl %eax, %eax
	xorl %edx, %edx
	movl lin, %eax
	mull maxim
	addl col, %eax
	
	//if (sudoku[lin][col] == 0) este spatiu liber
	cmp $0, (%edi, %eax, 4)
	je spatiu_liber
	
	//elementul curent este un numar setat
	cmp $8, col
	je linia_urm
	
	//apel recursiv pentru urmatorul element de pe linia curenta
	addl $1, col
	pushl col
	pushl lin
	call rezolva
	popl lin
	popl col 
	subl $1, col
	
	//if (rezolva(lin, col + 1) == 1) return 1;
	//else return 0;
	cmp $1, %eax
	je return_1
	
	jmp return_0
	
linia_urm:
	//apel recursiv pentru primul element de pe urmatoarea linie
	addl $1, lin
	pushl col   #salvez valoarea din col
	pushl $0
	pushl lin
	call rezolva
	popl lin
	popl col
	popl col
	subl $1, lin
	
	//if (rezolva(lin + 1, 0) == 1) return 1;
	//else return 0;
	cmp $1, %eax
	je return_1
	
	jmp return_0
		
spatiu_liber:	
	//daca elementul curent e 0 incerc sa pun in locul lui numere de la 1 la 9
	movl $1, %ecx
for_rezolva:
	cmp $10, %ecx
	je return_0
	
	//isOk(lin, col, %ecx) 
	pushl %ecx
	pushl col
	pushl lin
	call isOk    #returneaza 0 sau 1 in %eax
	popl lin
	popl col
	popl %ecx
	
	//if (isOk(lin, col, %ecx) != 1) continua for-ul penntru urmatorul numar
	cmp $1, %eax
	jne cont_for_rezolva

	//%eax = lin * 9 + col
	xorl %eax, %eax
	xorl %edx, %edx
	movl lin, %eax
	mull maxim
	addl col, %eax
	
	movl $sudoku, %edi	
	//sudoku[lin][col] = %ecx
	movl %ecx, (%edi, %eax, 4)
	
	//if (col == 8)
	cmp $8, col
	je linia_urm2
	
	//apel recursiv pentru urmatorul element de pe linia curenta
	pushl %ecx
	addl $1, col
	pushl col
	pushl lin
	call rezolva
	popl lin
	popl col
	subl $1, col
	popl %ecx
	
	//if (rezolva(lin, col + 1) == 1) return 1;
	cmp $1, %eax
	je return_1
	jmp reset_elem	
		
linia_urm2:
	//apel recursiv pentru primul element de pe urmatoarea linie
	pushl col  #salvez valoarea din col
	pushl %ecx
	addl $1, lin
	pushl $0
	pushl lin
	call rezolva
	popl lin
	popl col
	subl $1, lin
	popl %ecx
	popl col
	
	//if (rezolva(lin + 1, 0) == 1) return 1;
	cmp $1, %eax
	je return_1
	jmp reset_elem

reset_elem:
	//sudoku[lin][col] = 0;
	movl $sudoku, %edi
	xorl %eax, %eax
	xorl %edx, %edx
	//%eax = lin * 9 + col
	movl lin, %eax
	mull maxim
	addl col, %eax
	
	movl $0, (%edi, %eax, 4)

cont_for_rezolva:
	incl %ecx
	jmp for_rezolva

return_0:
	movl $0, %eax
	jmp rezolva_exit
	
return_1:
	movl $1, %eax
	jmp rezolva_exit
	
rezolva_exit:
	popl %edi
	popl %ebp
	ret
	

main:
	//f = fopen("sudoku.txt", "r");
	pushl $read
	pushl $fisierIn
	call fopen
	popl %ebx
	popl %ebx
	
	movl %eax, f
	
	//citesc din fisier
	movl $sudoku, %edi
	xorl %ecx, %ecx
cit_sudoku:
	cmp $81, %ecx
	je cont
	        
	pushl %ecx
	pushl $elem                         
	pushl $formatScanf
	pushl f
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx
	popl %ecx
	
	movl elem, %eax
	movl %eax, (%edi, %ecx, 4)
	
	incl %ecx
	jmp cit_sudoku
		
cont:
	//fclose(f);
	pushl f
	call fclose
	popl %ebx
	
a:
	pushl $0
	pushl $0
	call rezolva
	popl %ebx
	popl %ebx

	cmp $1, %eax
	je af_sudoku
	
	//g = fopen("sudoku_rezolvat.txt", "w");
	pushl $write
	pushl $fisierIesire
	call fopen
	popl %ebx
	popl %ebx
	
	movl %eax, g

	pushl $mesaj
	pushl g
	call fprintf
	popl %ebx
	popl %ebx

	jmp et_exit
	
af_sudoku:
	//g = fopen("sudoku_rezolvat.txt", "w");
	pushl $write
	pushl $fisierIesire
	call fopen
	popl %ebx
	popl %ebx
	
	movl %eax, g
	
	//scriu in fisier matricea
	movl $sudoku, %edi
	xorl %ecx, %ecx	
for_i:
	cmp maxim, %ecx
	je et_exit
	
	xorl %ebx, %ebx
for_j:
	cmp maxim, %ebx
	je cont_for_i
	
	//%edx = %ecx * 9 + %ebx
	xorl %edx, %edx
	movl %ecx, %eax
	mull maxim
	movl %eax, %edx
	addl %ebx, %edx
	
	pushl %ebx
	pushl %ecx
	pushl (%edi, %edx, 4)
	pushl $formatPrintf
	pushl g
	call fprintf
	popl %ebx
	popl %ebx
	popl %ebx
	popl %ecx
	popl %ebx
	
	incl %ebx
	jmp for_j

cont_for_i:	
	pushl %ebx
	pushl %ecx
	pushl $newline
	pushl g
	call fprintf
	popl %ebx
	popl %ebx
	popl %ecx
	popl %ebx

	incl %ecx
	jmp for_i
	
et_exit:
	//fclose(g);
	pushl g
	call fclose
	popl %ebx

	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
	
	

	

	