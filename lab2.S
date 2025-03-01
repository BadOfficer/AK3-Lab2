.global lab2
.syntax unified

#define A #5
#define B #4
#define C #0

lab2:
	push {lr}
	mov r0, A // load A to r0
	mov r1, B // load B to r1
	mov r2, C // load C to r2
	cmp r2, #0 // compare C with 0
	blt c_less_than_0 // if C < 0 go to c_less_than_0
	mov r5, #1 // r5 = 1(for factorial result)
	bl calculate_facto // calculate c!
	cmp r5, #12 // compare A * B with 12
	bgt calculate_func_1 // if A * B > 12, then go to calculate_func_1
	ble calculate_func_2 // if A * B <= 12, then go to calculate_func_2

calculate_func_1:
	and r4, r0, r1 // r4 = A & B
	lsr r4, #1 // r4 = (A & B) >>
	add r4, r5 // r4 = (A & B) >> + C!
	pop {pc} 
	
calculate_func_2:
	orr r4, r0, r1 // r4 = A | B
	lsl r4, #1 // r4 = (A | B) <<
	sub r4, r5 // r4 = (A | B) << - C!
	pop {pc}

calculate_facto:
	cmp r2, #0 // compare C with 0
	bne skip // if not equal go to skip
	mov r2, #1 // if C = 0 then C! = 1
	skip:
	mul r5, r2 // r5 = r5 * r2
	sub r2, #1 // r2 = r2 - 1
	cmp r2, #1 // compare r2 with 1
	bgt calculate_facto // if r2 > 1, then go to start calculate_facto
	bx lr

c_less_than_0:
	pop {pc}
