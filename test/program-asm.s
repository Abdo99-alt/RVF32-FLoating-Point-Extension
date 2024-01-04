addi s1, x0, 100
fcvt.s.w f1, s1
addi s2, x0, 4
fcvt.s.w f2, s2
fmul.s f3,f1,f2     #f3 takes the value of 400
addi s1, x0, 10
fcvt.s.w f4,s1
addi s2, x0, 4
fcvt.s.w f5,s2
fmul.s f6,f4,f5     #f6 takes the value of 40
fmin.s f7,f3,f6     #f7 takes the value of f6 -> 40
fle.s s3,f4,f5      #s3 takes the value of 0 since f4 > f5
fsw   f7,84(x0)      #mem[0] = 40
flw   f8,84(x0)      #f8 takes the value of mem[0] -> 40
fclass.s s3,f7      #s3 takes the value of 0x40 since the value stored in f7 is +ve normal
fadd.s f8,f3,f6
fsub.s f7,f3,f6
