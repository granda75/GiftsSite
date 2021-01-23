
function UploadFile()
{
    var data = new FormData();

    var files = $("#imageFile").get(0).files;

    // Add the uploaded image content to the form data collection
    if (files.length > 0) {
        data.append("UploadedImage", files[0]);
    }

    // Make Ajax request with the contentType = false, and procesData = false
    var ajaxRequest = $.ajax({
        type: "POST",
        url: "JQGridHandler.ashx",
        contentType: false,
        processData: false,
        data: data
    });

    ajaxRequest.done(function (xhr, textStatus) {
        // Do other operation
    });
   
}

function ClearDialogFields()
{
    $('#txtProductName').val('');
    $('#txtDescription').val('');
    $('#txtId').val('');
    $('#txtDate').val('');
    $("#imageFile").val('');
}

function EditProduct(isInsert) {
    var url = "JQGridHandler.ashx";

    var imageName = $('#imageFile').val();
    var parts = imageName.split("\\");
    if (parts && parts.length > 0)
    {
        imageName = parts[parts.length - 1];
    }

    var productName = $('#txtProductName').val();
    var description = $('#txtDescription').val();
    var id = $('#txtId').val();
    var date = $('#txtDate').val();
    var operation = (isInsert == "1") ? 'add' : 'edit';
    if (isInsert == "1")
    {
        id = 0;
    }

    var dataParams = {
        "Id": id,
        "ProductName": productName,
        "Description": description,
        "SaleDate": date,
        "ImageFileName": imageName,
        "Operation": operation
    };

    $.ajax({
        url: url,
        data: JSON.stringify(dataParams),
        beforeSend: function (xhr, settings) {
            $("[id$=processing]").dialog();
        },
        type: "POST",
        cache: false,
        dataType: "json"
    })
    .done(function (model) {
        alert(model);
        $("#grid").trigger("reloadGrid", [{ current: true }]);
    })
    .fail(function (data)
    {
        alert(data);
    }); //success

}

function ShowNewProductDialog()
{
    $("#isInsert").val(1);
    $("#editDialog").dialog("open");
    $("#imgId").hide();
    
    ClearDialogFields();
}

function ShowEditDialog()
{
    $("#isInsert").val(0);
    $("#imgId").show();

    var selRowId = $("#grid").jqGrid('getGridParam', 'selrow');
    if (selRowId != null)
    {
        var productName = $("#grid").jqGrid('getCell', selRowId, 'ProductName');
        var description = $("#grid").jqGrid('getCell', selRowId, 'Description');
        var saleDate = $("#grid").jqGrid('getCell', selRowId, 'SaleDate');
        var imageName = $("#grid").jqGrid('getCell', selRowId, 'ImageFileName');
        var imageSrc = $(imageName).attr('src');

        var sDate = moment(saleDate).format('DD-MM-YYYY');

        $("#txtId").val(selRowId);
        $("#txtProductName").val(productName);
        $("#txtDescription").val(description);
        $("#txtDate").val(sDate);
        $("#imgId").attr("src", imageSrc);

        $("#editDialog").css("direction", "rtl");
        $("#editDialog").dialog("open");

    }
    else {
        alert("Please Select Row");
    }
}

function LoadData() {
    
    $("#grid").jqGrid
        ({
            url: "JQGridHandler.ashx",
            direction: "rtl",
            datatype: 'json',
            mtype: 'Get',
            //mtype: 'POST',
            serializeGridData: function (postData) {
                
                return JSON.stringify(postData);
            },
          

            loadonce: false,

            //table header name   
            colNames: ["תמונה", 'קוד מוצר', 'שם מוצר', 'תיאור מוצר', 'תאריך תחילת מחירה'],

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
                    sorttype: "int",
                    searchoptions: { sopt: ['eq'] },
                    sortable: true,
                    editable: false
                },
                {
                    key: false,
                    name: 'ProductName',
                    index: 'ProductName', 
                    sorttype: "text",
                    sortable: true,
                    editable: true
                },
                {
                    key: false,
                    name: 'Description',
                    index: 'Description',
                    sorttype: "text",
                    sortable: true,
                    editable: true
                },
                {
                    key: false,
                    name: 'SaleDate',
                    index: 'SaleDate',
                    sorttype: "date",
                    sortable: true,
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
                edit: false,
                add: false,
                del: true,
                search: true,
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
            , {
                // add options  
                zIndex: 100,
                url: "JQGridHandler.ashx",
                closeOnEscape: true,
                closeAfterAdd: true,
                afterComplete: function (response) {
                    if (response.responseText) {
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
                
            }
            , {
                closeOnEscape: true, multipleSearch: true,
                closeAfterSearch: true
            }, // search options
            {}
        );

}