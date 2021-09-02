generic
   size: integer;
   type itemType is private;

package CreateList is
   procedure AddToList( ListItem: in itemType);
   procedure PrintList;
   procedure PrintItem( pt: in integer);
   procedure DeleteItem( pt: in integer);
   function ListLength return integer;
end CreateList;
