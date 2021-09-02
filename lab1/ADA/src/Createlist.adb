with ADA.Text_IO; use Ada.Text_IO;

package body CreateList is
   len: Integer range 0..size;
   list:array(1..size) of itemType;

   procedure AddToList( ListItem: in itemType) is
   begin

      if size>ListLength then
         len:= len +1;
         list(len):=ListItem;

         end if;
null;

   end AddToList;

   procedure PrintList is
   begin
      if len=0 then
         put("null");
      elsif len>0 then
         for x in 1..ListLength loop

            new_line;
            end loop;
         end if;

   end PrintList;

   procedure PrintItem( pt: in integer) is
   begin
null;
   end PrintItem;

   procedure DeleteItem( pt: in Integer) is
   begin
      len:= len-1;
   end DeleteItem;

   Function ListLength return Integer is
   begin
      return len;
   end ListLength;


begin
      len:=0;
end CreateList;
