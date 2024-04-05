--------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 7.1
"Dynamic Programs (Dynpros) – Update Pocket Calculator
"Create a new report that starts a dynpro that allows to carry out calculations with the four basic arithmetic operations. The dynpro should
"have two input fields for the two operands, an input field for the operator ("+", "-", "*", "/"), an output field for the result and a button for
"executing the calculation (see screenshot). Consider possible errors (e. g., division by zero, unknown operator) and
"handle them appropriately (→ MESSAGE). Use appropriate data elements and/or domains or create new ones if necessary

--------------------------------------------------------------------------------------------------------------------------------------------------------------

MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'CALC'.
      CASE operator.

        WHEN '+'.
          result = num1 + num2.

        WHEN '-'.
          result = num1 - num2.

        WHEN '*'.
          result = num1 * num2.

        WHEN '/'.
          IF num2 = 0.
            MESSAGE |'Cannot be divided by zero,Sorry.'| TYPE 'E'.
          ELSE.
            result = num1 / num2.
          ENDIF.



      ENDCASE.


  ENDCASE.

  CLEAR ok_code.


ENDMODULE.

--------------------------------------------------------------------------------------------------------------------------------------------------------------

"Assignment 7.2
"Dynamic Programs (Dynpros)with Transaction Code – Create Student Create a new transaction (transaction code) that starts a dynpro that
"allows to create new students in the students table. The dynpro should have input fields for the necessary information and a button for 
"saving the entries or for deleting the input fields (see screenshot). Use the function module from Assignment 5.2 to create the entries. After
"successful creation, an information message (-> Message) with the newly created matriculation number should be issued and the input fields for a new 
"entry should be deleted. If the creation fails, an error message should be issued.

--------------------------------------------------------------------------------------------------------------------------------------------------------------

MODULE user_command_0100 INPUT.

  TABLES: z30923712_st_rec.

  DATA: fname   TYPE  z30923712_st_rec-first_name,
        lname   TYPE z30923712_st_rec-last_name,
        db      TYPE z30923712_st_rec-date_of_birth,
        ok_code LIKE sy-ucomm.

  DATA: gs_student   TYPE z30923712_st_rec,
        gt_student   TYPE TABLE OF z30923712_st_rec,
        gv_matri_num TYPE z30923712_st_rec-matri_num.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN 'ADD'.

      " Get the next matriculation number
      SELECT MAX( matri_num ) INTO gv_matri_num FROM z30923712_st_rec.
      gv_matri_num = gv_matri_num + 1.
      gs_student-matri_num = gv_matri_num.

gs_student-first_name = fname.
gs_student-last_name = lname.
gs_student-date_of_birth = db .
      " Insert the new student into the table
     MODIFY z30923712_st_rec FROM gs_student.


      " Check for successful insertion
      IF sy-subrc = 0.
        " Display success message
        MESSAGE |'Record successfully created in the database.'| TYPE 'S'.

        " Clear input fields for a new entry
        CLEAR : fname, lname, db.

      ELSE.
     MESSAGE |'Error creating record in the database'| TYPE 'E'.   .


        " Display generic error message
      ENDIF.

  ENDCASE.
ENDMODULE.

--------------------------------------------------------------------------------------------------------------------------------------------------------------
