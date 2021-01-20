<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GiftsSite._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" >

       <script type="text/javascript">
            //alert("Hello, Default !");
           $(document).ready(function () {

               LoadData();
              
           });

           function LoadData()
           {
               var source =
               {
                   localdata: generatedata(500),
                   datafields:
                       [
                           { name: 'Id', type: 'number' },
                           { name: 'ProductName', type: 'string' },
                           { name: 'Description', type: 'string' },
                           { name: 'SaleDate', type: 'date' }

                       ],
                   datatype: "array"
               };

               var dataAdapter = new $.jqx.dataAdapter(source);
               var columns = [
                   { text: 'קוד מוצר', dataField: 'Id', width: 130 },
                   { text: 'שם מוצר', dataField: 'ProductName', width: 130 },
                   { text: 'תיאור מוצר', dataField: 'Description', width: 180 },
                   { text: 'תאריך תחילת מחירה', dataField: 'SaleDate', width: 80, cellsalign: 'right' }

               ];

               // create data grid.
               $("#grid").jqxGrid(
                   {
                       width: getWidth('Grid'),
                       height: 300,
                       source: dataAdapter,
                       columns: columns
                   });

               // init buttons.
               $("#refresh").jqxButton({ theme: theme });
               $("#clear").jqxButton({ theme: theme });

               $("#refresh").click(function () {
                   source.localdata = generatedata(500);
                   // passing "cells" to the 'updatebounddata' method will refresh only the cells values when the new rows count is equal to the previous rows count.
                   $("#grid").jqxGrid('updatebounddata', 'cells');
               });

               $("#clear").click(function () {
                   $("#grid").jqxGrid('clear');
               });
           }
       </script>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br><br>
    

   <%-- <body>--%>
    <div class="container">
    <h1 dir="rtl"> ניהול מוצרים</h1>
    </div>    
    <div dir="rtl">
       
        <div id='jqxWidget'>
        <div id="grid">
        </div>
     <%--   <div style="margin-top: 10px;">
            <input id="refresh" type="button" value="Refresh Data" />
            <input id="clear" type="button" value="Clear" />
        </div>--%>
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
   <%-- <div id='jqxWidget' style="font-size: 13px; font-family: Verdana; float: left;">
        <div id="grid">
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
    </div>--%>


    <%--</body>--%>
</div>

</asp:Content>
