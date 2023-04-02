extern vgaWrite

%macro print 1
mov esi, %1
call vgaWrite
%endmacro