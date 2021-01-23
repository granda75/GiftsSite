<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GiftsSite._Default" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" >

       <script type="text/javascript">

           $(document).ready(function ()
           {
               $("#editDialog").css("display", "none");
               
               LoadData();
              
               $("#editDialog").dialog({
                   autoOpen: false,
                   minHeight: 300,
                   minWidth: 600,
                   modal: true,
                   resizable: false,
                   buttons: [
                       {
                           text: "אישור",
                           click: function ()
                           {
                               $(this).dialog("close");
                               var isAdding = $("#isInsert").val();
                              
                               EditProduct(isAdding);
                           }


                       },
                       {
                           text: "ביטול",
                           click: function () { $(this).dialog("close"); }
                       }
                   ]

               });
               
               $('.ui-dialog-titlebar-close').remove();
               $("#btnEdit").click(ShowEditDialog);
               $("#btnAdd").click(ShowNewProductDialog);
               $("#btnUploadFile").click(UploadFile);

               $(".datepicker").datepicker(
                   {
                       dateFormat: 'dd/mm/yy'
                   });
              
           });

    
       </script>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    
    <div class="container">
      <div class="row justify-content-center">
        <h2 class="text-center">ניהול מוצרים</h2>
      </div>
    </div>

    <div class="container" dir="rtl">
        <div>  
            <table id="grid"></table>  
            <div id="pager"></div>  
        </div>  
        <br>
        <div class="row">  
            <input type="button" id="btnEdit" class="float-right" style="margin-right:15px;"  value="עריכת מוצר" />
            <input type="button" id="btnAdd" class="float-right" style="margin-right:15px;"  value="הוספת מוצר" />
        </div>  
    </div>
   
    <div id="outer" class="container text-right">
        <div id="editDialog"  dir="rtl" class="row text-right">

            <table style="width: 100%;" class="text-right" dir="rtl" id="editDialogTable">
                <tr>
                    <td>תמונת מוצר</td>
                    <td><img src="" id="imgId" width="55" height="55">
                        <input type="file" id="imageFile" name="productImage" accept="image/jpeg" />
                    </td>
                    <td>
                        <input id="btnUploadFile" type="button" value="שמור תמונה" />
                    </td>
                </tr>
                
                <tr>
                    <td>שם מוצר</td>
                    <td>&nbsp;  <input id="txtProductName" type="text" /></td>
                </tr>
                <tr>
                    <td>תאור</td>
                    <td>&nbsp;   <input id="txtDescription" type="text" /></td>
                </tr>
               <tr>
                    <td>תאריך</td>
                    <td>&nbsp;   <input id="txtDate" type="text" class="datepicker"/></td>
                </tr>
            </table>
            <input id="txtId" type="text" style="display:none" />
            <input id="isInsert" type="text" style="display:none" />
        </div>
    </div>


</asp:Content>
