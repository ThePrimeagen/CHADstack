

       identification division.
       program-id. anotherroute.

       data division.
       working-storage section.

       01 the-vars.

          03  COW-vars OCCURS 99 times.

            05 COW-varname       pic x(99).
            05 COW-varvalue      pic x(99).


       procedure division.

           call 'cowtemplate' using the-vars "anotherroute.cow".


       goback.

       end program anotherroute.


