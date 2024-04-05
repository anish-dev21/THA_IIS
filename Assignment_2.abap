---------------------------------------------------------------------------------------------------------------------------

"Assignment 2.1 - Control Structures and Output
"Implement a calculation table that allows one of the four basic
"arithmetic calculations (+, -, /, * selected by the user) on the
"numbers 0 through 10.
"The output should be formatted as follows:
"+ 0 1 2 ... 10
"0 0 1 2 ... 10
"1 1 2 3 ... 11
"2 2 3 4 ... 12
"... ... ... ... ... ...
"10 10 11 12 ... 20
"The selected operator should be printed in the first column and
"first line, followed by the numbers from 0 to 10. The same applies
"to the first column of all lines. The cells at the junctions should
"contain the result of the operation. Use loops and the options for
"formatted output of the WRITE command. Horizontal lines can be
"created with the ULINE command, vertical lines with the pipe
"character ("|") or via SY-VLINE. A division by zero should be done
"by outputting a red "X" in the corresponding cell (COLOR).

----------------------------------------------------------------------------------------------------------------------------

REPORT z30923_712_ass2_1.

DATA: initial_value TYPE p DECIMALS 2,
      running_total TYPE p DECIMALS 2,
      result        TYPE p DECIMALS 2.

PARAMETERS oper TYPE c LENGTH 1.     " Declare a parameter for the operation choice.


DO 12 TIMES.
  WRITE: '|'.
  running_total = sy-index - 1.      " Calculate the running total based on the current loop index.

    IF running_total = 0.
      WRITE (5) oper CENTERED.         " Display the operation symbol centered in a field of width 5.
    ELSE.
      running_total = sy-index - 2.     " Calculate a modified running total for non-zero cases.
      WRITE: (5) running_total CENTERED.   " Display the modified running total centered in a field of width 5.
    ENDIF.


  ENDDO.

  WRITE sy-vline.                       " Draw a vertical line.
  ULINE.                                " Draw a horizontal line (underline).


  DO 11 TIMES.
    WRITE sy-vline.
    WRITE: (5) initial_value CENTERED.       " Display the initial value centered in a field of width 5.
    DO 11 TIMES.
      WRITE sy-vline.
      CASE oper.                             " Addition operation.
        WHEN '+'.
          result = initial_value + ( sy-index - 1 ).
          WRITE (5) result CENTERED.                " Display the result of addition centered in a field of width 5.
        WHEN '-'.
          result = initial_value - ( sy-index - 1 ).
          WRITE (5) result CENTERED.                 " Display the result of subtraction centered in a field of width 5.
        WHEN '*'.
          result = initial_value * ( sy-index - 1 ).
          WRITE (5) result CENTERED.                  " Display the result of multiplication centered in a field of width 5.
        WHEN '/'.
          IF ( sy-index - 1 ) = 0.                    " Check for division by zero.
            WRITE (5) 'X' CENTERED  COLOR 6 .         " Display 'X' in red if division by zero.
          ELSE.
            result = initial_value / ( sy-index - 1 ).
            WRITE (5) result CENTERED.                " Display the result of division centered in a field of width 5.
          ENDIF.
      ENDCASE.
    ENDDO.
    initial_value = initial_value + 1.                 " Increment the initial value for the next row.
    WRITE sy-vline.
    ULINE.

  ENDDO.

-------------------------------------------------------------------------------------------------------------------------------

"Assignment 2.2. - Control Structures and Output
"Create a report that calculates the checksum of a user-entered
"sequence of digits and then prints it on the screen (use the
"commands STRLEN and SHIFT).
"Example of output:
"The checksum of 12345 is 15

----------------------------------------------------------------------------------------

REPORT Z30923_712_ASS2_2.

PARAMETERS: u_inp(10) TYPE C.

DATA: in_str(10) TYPE C,
      checksum TYPE i VALUE 0,  " Declare a variable to store the checksum, initialized to 0.
      len TYPE i,
      i TYPE i.

  in_str = u_inp.               " Copy the user input into the in_str variable.
  len = strlen( in_str ).       " Calculate the length of the input string.
  i = 1.                        " Initialize the loop counter to 1.
  checksum = 0.                 " Initialize the checksum to 0.

  DO len TIMES.                    " Start a loop that runs for the length of the input string.
    SHIFT in_str LEFT BY strlen( u_inp ) - 1 PLACES.     " Shift in_str to the left by (length - 1) places.
    SHIFT u_inp LEFT CIRCULAR BY 1 PLACES.               " Circular shift the user input to the left by 1 place.

    checksum = checksum + in_str.                  " Add the numerical value of in_str to the checksum.
    in_str = u_inp.                                " Reset in_str to the original user input.


  ENDDO.
WRITE: 'The checksum of', u_inp, ' is', checksum.

----------------------------------------------------------------------------------------

"Assignment 2.3. - Control Structures and Output
"Write a report printing the first ten fibonacci numbers using a loop
"(DO or WHILE). Fibonacci is defined as follows:
"Fn = Fn−1 + Fn−2 with F0 = 0 and F1 = 1

----------------------------------------------------------------------------------------

REPORT z30923_712_ass2_3.

DATA: n1       TYPE i VALUE 0,
      n2       TYPE i VALUE 1,
      n_num TYPE i,              " Variable to store the next Fibonacci number
      count    TYPE i VALUE 0.

WHILE count < 10.                " Looping until counter reaches 10

  WRITE: / n1.                   " Calculate the next Fibonacci number
  n_num = n1 + n2.               " Update n1 and n2 for the next iteration

  n1 = n2.                       " Update n1 with the previous value of n2
  n2 = n_num.                    " Update n2 with the current Fibonacci number

  ADD 1 TO count.                " Increment the counter



