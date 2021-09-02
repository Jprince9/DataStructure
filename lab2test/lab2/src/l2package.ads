generic
      
   type itemType is private;
   with procedure Put(X: Itemtype);
      
package l2package is
   
   procedure insertNodeLeft
   procedure insertNodeRight(deptNameIn);
   procedure deleteNodeLeft(deptNameIn: itemType);
   procedure deleteNodeRight(deptNameIn: itemType);
   procedure deleteDepartment(deptNameIn: itemType);
   procedure printAllDepartments()
   procedure printDepartment(deptNameIn: itemType);
      
      
      
end l2package;
