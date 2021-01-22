<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GiftsSite._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" >

       <script type="text/javascript">

           $(document).ready(function () {
               $("#editDialog").css("display", "none");
               debugger;
               LoadData();
              
               $("#editDialog").dialog({
                  // autoOpen: false, modal: true, show: "blind", hide: "blind"
                   autoOpen: false,
                   minHeight: 300,
                   minWidth: 500,
                   modal: true,
                   resizable: false,
                   buttons: [
                       {
                           text: "אישור",
                           click: function ()
                           {
                               $(this).dialog("close");
                               EditProduct();
                           }


                       },
                       {
                           text: "ביטול",
                           click: function () { $(this).dialog("close"); }
                       }
                   ]

               });
               
               $('.ui-dialog-titlebar-close').remove();
             

               $("#bedata").click(ShowEditDialog);
              
           });

           function EditProduct()
           {
               var url = "JQGridHandler.ashx";

               var dataParams = {
                   "Id": 23,
                   "ProductName": 'wallet2',
                   "Description": 'wallet2',
                   "SaleDate": '2021-01-22',
                   "ImageFileName": 'wallet.jpg',
                   "Operation": 'edit'
               };

               $.ajax({
                   url: url,
                   //data: JSON.stringify(data),
                   data: JSON.stringify(dataParams),
                   beforeSend: function (xhr, settings) {
                       $("[id$=processing]").dialog();
                   },
                   type: "POST",
                   //contentType: "application/json",
                   cache: false,
                  
                   dataType: "json"
               })
                   .done(function (model) {
                       alert("Success!");
                       //if (model != null) {
                       //    if (model.IsChangeSaleSucceeded == true) {
                       //        var message = " ערוץ המכירה עודכן בהצלחה";
                       //        $.utils.messageBox($('#grid-details'), message, "rtl");
                       //    }
                       //    else {
                       //        var message = " השינוי ערוץ מכירה לא הצליח";
                       //        $.utils.messageBox($('#grid-details'), message, "rtl");
                       //    }

                       //}
                   }); //success
           }

           function ShowEditDialog()
           {
               var selRow = $("#grid").jqGrid('getGridParam', 'selrow');
               if (selRow != null)
               {
                   $("#editDialog").css("direction", "rtl");
                   $("#editDialog").dialog("open");
                   //$(".ui-dialog-title").css("direction", "rtl");
               }
               else {
                   alert("Please Select Row");
               }
                   
           }

           function LoadData()
           {
                   debugger;
                   $("#grid").jqGrid
                       ({
                           url: "JQGridHandler.ashx",
                           direction: "rtl",
                           datatype: 'json',
                           mtype: 'Get',
                           //mtype: 'POST',
                           serializeGridData: function (postData) {
                               debugger;
                               return JSON.stringify(postData);
                           },

                           loadonce: false,

                           //table header name   
                           colNames: ["תמונה", 'קוד מוצר' ,'שם מוצר', 'תיאור מוצר', 'תאריך תחילת מחירה'],
                           
                           //colModel takes the data from controller and binds to grid   
                           colModel: [
                               {
                                   key: false,
                                   hidden: false,
                                   name: 'ImageFileName',
                                   index: 'ImageFileName',
                                   width: 60,
                                   fixed: true,
                                   formatter: function (cellvalue, options) {
                                       debugger;
                                       
                                       var imageUrl = '/images/' + cellvalue;
                                       var imageElement = "<img src=" + imageUrl + " height=55 width = 55" + " />";
                                       return imageElement;
                                   },
                                   editable: true
                               },
                               {
                                   key: true,
                                   hidden: false,
                                   name: 'Id',
                                   index: 'Id',
                                   editable: false
                               },
                               {
                                   key: false,
                                   name: 'ProductName',
                                   index: 'ProductName',
                                   editable: true
                               },
                               {
                                   key: false,
                                   name: 'Description',
                                   index: 'Description',
                                   editable: true
                               },
                               {
                                   key: false,
                                   name: 'SaleDate',
                                   index: 'SaleDate',
                                   sorttype: "date",
                                   edittype: "date",
                                   formatter: "date",
                                   formatoptions: {
                                       "srcformat": "u1000",
                                       "newformat": "m/d/Y H:i:s"
                                   },
                                   editable: true
                               }],

                           rowNum: 10,
                           rowList: [10, 20, 30, 40],
                           pager: '#pager',
                           height: '100%',
                           viewrecords: true,
                           caption: 'רשימת מוצרים',
                           emptyrecords: 'No records to display',
                           jsonReader:
                           {
                               root: "rows",
                               page: "page",
                               total: "total",
                               records: "records",
                               repeatitems: false,
                               Id: "0"
                           },
                           autowidth: true,
                           multiselect: false
                           //pager-you have to choose here what icons should appear at the bottom  
                           //like edit,create,delete icons  
                       }).navGrid('#pager',
                           {
                               edit: true,
                               add: true,
                               del: true,
                               search: false,
                               refresh: true,
                               afterShowForm: function ($form) {
                                   var dialog = $form.closest('div.ui-jqdialog'),
                                       selRowId = myGrid.jqGrid('getGridParam', 'selrow'),
                                       selRowCoordinates = $('#' + selRowId).offset();
                                   dialog.offset(selRowCoordinates);
                               },
                           },
                           {
                           // edit options  
                                //EDIT
                            height: 300,
                            width: 400,
                            top: 350,
                            left: -250,
                            dataheight: 280,
                            zIndex: 100,
                            //top: 250,
                            //left: 250,
                           url: 'JQGridHandler.ashx',
                           closeOnEscape: true,
                           closeAfterEdit: true,
                           recreateForm: true,
                           formEditing: {
                                afterShowForm: function ($form) {
                                    $form.closest(".ui-jqdialog").position({
                                        my: "center",
                                        at: "center",
                                        of: window
                                    });
                                }
                            },
                           afterComplete: function (response) {

                               if (response.responseText) {
                                   alert(response.responseText);
                               }
                           }
                       }
                         ,  {
                           // add options  
                           zIndex: 100,
                             url: "JQGridHandler.ashx",
                           closeOnEscape: true,
                           closeAfterAdd: true,
                           afterComplete: function (response) {
                               if (response.responseText)
                               {
                                   alert(response.responseText);
                               }
                           }
                           }
                           , {
                           // delete options  
                           zIndex: 100,
                           url: "JQGridHandler.ashx",
                           closeOnEscape: true,
                           closeAfterDelete: true,
                           recreateForm: true,
                           msg: "אתה בטוח שאתה רוצה למחוק את המוצר  ?",
                         
                            afterSubmit: function (response, postdata) {
                                if (response.responseText == "") {

                                    $("#grid").trigger("reloadGrid", [{ current: true }]);
                                    return [false, response.responseText]
                                }
                                else {
                                    $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                    alert(response.responseText);
                                    return [true, response.responseText]
                                }
                            }
                               //,delData: {
                               //    Id: function () {
                               //        debugger;
                               //        var sel_id = $('#grid').jqGrid('getGridParam', 'selrow');
                               //        //var value = $('#grid').jqGrid('getCell', sel_id, '_id');
                               //        //return value;
                               //        return sel_id;
                               //    }
                               //}
                            
                       });
          
           }

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

    <div dir="rtl">
       
        <div>  
            <table id="grid"></table>  
            <div id="pager"></div>  
            <input type="button" id="bedata" value="Edit Selected" />
        </div>  
     
          <div id="eventslog" style="display: none; margin-top: 30px;">
            <div style="float: left;">
                Event Log:
                <div style="border: none;" id="events">
                </div>
            </div>
            <div style="float: left;">
                Paging Details:
                <div id="paginginfo">
                </div>
            </div>
        </div>
    </div>
   
    <div id="outer" class="rtl">
        <div id="editDialog" class="rtl" title="עריכת מוצר" dir="rtl">
            <table style="width: 100%;">
                <tr>
                    <td>תמונת מוצר</td>
                    <td>&nbsp; <input type="file" name="productImage" accept="image/jpeg" /></td>
                </tr>
                <tr>
                    <td>שם מוצר</td>
                    <td> <input id="txtProductName" type="text" /></td>
                </tr>
                <tr>
                    <td>תאור</td>
                    <td>&nbsp;   <input id="txtDescription" type="text" /></td>
                </tr>
               <tr>
                    <td>תאריך</td>
                    <td>&nbsp;   <input id="txtDate" type="text" /></td>
                </tr>

            </table>
        </div>
    </div>


</asp:Content>
