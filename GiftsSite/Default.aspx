<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GiftsSite._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" >

       <script type="text/javascript">


           $(document).ready(function () {

               LoadData();
              
           });


           function LoadData()
           {
                   debugger;
                   $("#grid").jqGrid
                       ({
                           url: "http://localhost:44317/JQGridHandler.ashx",
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
                           colNames: ['קוד מוצר', 'שם מוצר', 'תיאור מוצר', 'תאריך תחילת מחירה'],
                           
                           //colModel takes the data from controller and binds to grid   
                           colModel: [
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
                               refresh: true
                           }, {
                           // edit options  
                           zIndex: 100,
                           url: '/Default/Edit',
                           closeOnEscape: true,
                           closeAfterEdit: true,
                           recreateForm: true,
                           afterComplete: function (response) {
                               if (response.responseText) {
                                   alert(response.responseText);
                               }
                           }
                       }
                         ,  {
                           // add options  
                           zIndex: 100,
                           url: "/Default/Create",
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
                             url: "/Default/Delete",
                           closeOnEscape: true,
                           closeAfterDelete: true,
                           recreateForm: true,
                           msg: "Are you sure you want to delete this task?",
                           afterComplete: function (response) {
                               if (response.responseText) {
                                   alert(response.responseText);
                               }
                           }
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
    

   <%-- <body>--%>
    
    <div class="container">
      <div class="row justify-content-center">
        <h2 class="text-center">ניהול מוצרים</h2>
      </div>
    </div>

    <div dir="rtl">
       
        <div>  
            <table id="grid"></table>  
            <div id="pager"></div>  
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
   
<%--</div>--%>

</asp:Content>
