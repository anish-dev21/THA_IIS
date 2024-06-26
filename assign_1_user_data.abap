"Personalized hello world!
"Write a code in ABAP so that it is possible to enter your own name that is then printed on the
"output list (→ PARAMETERS). Example for output: Hello, <Own name>!
----------------------------------------------------------------------------------------

REPORT Z30923_712_ASS1_3.

Data: name TYPE string.

Parameters: p_name TYPE string LOWER CASE DEFAULT 'Your Name'.

name = p_name.

Write: 'Hello', name, '!'.

----------------------------------------------------------------------------------------

"Time dependent greetings
"Copy the report from Task (1.3.) into a new report.
"Copy the report from Task (1.3.) into a new report. The program should be
"modified so that a different greeting text is used depending on the time of day
"(→ IF):
"- Morning: "Good morning, <name>!"
"- Afternoon: "Hello, <name>!"
"- Evening: "Good evening, <name>!"
"To do this, use a case distinction and the system field → SY-UZEIT

----------------------------------------------------------------------------------------

REPORT Z30923_712_ASS1_4.

Data: name TYPE string,
      greeting TYPE string,
     gtime TYPE t.

Parameters: p_name TYPE string LOWER CASE DEFAULT 'Your Name'.

GET TIME FIELD gtime.

  IF gtime < '120000'. "Morning (before 12:00 PM).

Write: 'Good morning' && p_name &&'!'.

ELSEIF gtime < '180000'. "Afternoon (before 6:00 PM).

Write: 'Hello, ' && p_name &&'!'.

ELSE.    "Evening.

Write: 'Good evening, ' && p_name && '!'.

ENDIF.

----------------------------------------------------------------------------------------

"Pocket Calculator
"Write an ABAP program that does the following:
"- Input: two operands and one operator ("+", "-", "*", "/") (→ PARAMETERS)
"- Processing: calculation of the result erg = operand1 "operator" operand2
"- Output: Result as well as the input values, formatted in such a way that
"it is clear what has been calculated.
"The four basic arithmetic operations should be possible as operators. The
"operands should be decimal numbers with 3 decimal places. Select a suitable
"data type for this. The division by Zero should be handled with a suitable
"message on the screen.

----------------------------------------------------------------------------------------

REPORT Z30923_712_ASS1_5.

PARAMETERS : Input1 TYPE int2,
             Input2 TYPE int2.
DATA: lv_out  TYPE int2,
      lv_sign TYPE c,
      flag    TYPE int1 VALUE 0.

SELECTION-SCREEN :BEGIN OF SCREEN 500 TITLE BEGIN,  "Where we create a screen with number 500
                  PUSHBUTTON /10(10) add  USER-COMMAND add,
                  PUSHBUTTON 25(10) sub USER-COMMAND sub,
                  PUSHBUTTON 40(10) mul USER-COMMAND multiply,
                  PUSHBUTTON 55(10) div USER-COMMAND divide,

END OF SCREEN 500.

INITIALIZATION. " Initializion of the value of our buttons
  add = 'Add'.
  sub = 'Subtract'.
  mul = 'Multiply'.
  div = 'Division'.

AT SELECTION-SCREEN. "Calculation screen

  CASE sy-ucomm.

    WHEN 'ADD'.
      flag = 1.
      lv_out = Input1 + Input2.

    WHEN 'SUB'.
      flag = 1.
      lv_out = Input1 - Input2.

    WHEN 'DIVIDE'.
      IF ( Input2 <> 0 ).
        flag = 1.
        lv_out = Input1 / Input2.

      ELSE.
        flag = 2.

      ENDIF.

    WHEN 'MULTIPLY'.
      flag = 1.
      lv_out = Input1 * Input2.

  ENDCASE.

      START-OF-SELECTION.

  IF Input1 IS NOT INITIAL OR Input2 IS NOT INITIAL.
    CALL SELECTION-SCREEN '500' STARTING AT 10 10. " Calling screen 500 we created earlier.

    IF flag = 1.
      WRITE: lv_out.

    ELSEIF flag = 2.
      WRITE: 'Cannot Divide a number by 0'.

    ELSEIF flag = 0.
      MESSAGE 'Press any Button to perform any operation!' TYPE 'I'.

      ENDIF.
  ELSE.
    MESSAGE 'Please give both the Inputs to proceed!' TYPE 'I'.
  ENDIF.
