using GiftsBL;
using GiftsEntity;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Web;
using System.Web.Script.Serialization;

namespace GiftsSite
{
    /// <summary>
    /// Summary description for JQGridHandler
    /// </summary>
    public class JQGridHandler : IHttpHandler
    {
        #region Methods

        public void ProcessRequest(HttpContext context)
        {
            string conString = ConfigurationManager.ConnectionStrings["GiftsDB"].ConnectionString;
            NameValueCollection forms = context.Request.Form;
            string strOperation = forms.Get("oper");
            string queryString = HttpUtility.UrlDecode(context.Request.QueryString.ToString());
            GridPageData pageData = JsonConvert.DeserializeObject<GridPageData>(queryString);

            string strResponse = string.Empty;
            var jsonSerializer = new JavaScriptSerializer();
            ProductsBL bl = new ProductsBL(conString);
            var format = "dd/MM/yyyy"; // your datetime format
            var dateTimeConverter = new IsoDateTimeConverter { DateTimeFormat = format };

            if (context.Request.Files.Count > 0)
            {
                UploadFile(context, jsonSerializer);
                return;
            }

            if (strOperation == null)
            {
                string parameters = HttpUtility.UrlDecode(context.Request.Params.ToString());
                string[] parts = parameters.Split('}');
                if (parts != null && parts.Length > 0)
                {
                    string productStr = parts[0] + "}";
                    if (!string.IsNullOrEmpty(productStr) && productStr.Contains("edit"))
                    {
                        strResponse = ProcessProductEdit(context, jsonSerializer, bl, dateTimeConverter, productStr);
                        return;
                    }
                    else if (productStr.Contains("add"))
                    {
                        strResponse = ProcessProductInsert(context, jsonSerializer, bl, dateTimeConverter, productStr);
                        return;
                    }
                }
               
                //oper = null which means its first load.
                ProductData productsData = bl.GetProductsData(pageData.page, pageData.rows);

                var jsonData = new
                {
                    total = productsData.TotalPages,
                    page = pageData.page,
                    records = productsData.TotalRows,
                    rows = productsData.ProductsList
                };

                context.Response.Write(jsonSerializer.Serialize(jsonData));
               
            }
            else if (strOperation == "del")
            {
                strResponse = ProcessRemoveProduct(context, forms, bl);
            }
        }

        private static string ProcessRemoveProduct(HttpContext context, NameValueCollection forms, ProductsBL bl)
        {
            string strResponse;
            int productId = Int32.Parse(forms.Get("Id"));
            bool isSuccess = bl.RemoveProduct(productId);
            strResponse = (isSuccess) ? "המוצר נמחק בהצלחה" : "שגיאה, המוצר לא נמחק";
            context.Response.Write(strResponse);
            return strResponse;
        }

        private static string ProcessProductInsert(HttpContext context, JavaScriptSerializer jsonSerializer, ProductsBL bl, IsoDateTimeConverter dateTimeConverter, string productStr)
        {
            string strResponse;
            Product product = JsonConvert.DeserializeObject<Product>(productStr, dateTimeConverter);
            bool isSuccess = bl.InsertProduct(product);
            strResponse = (isSuccess) ? "המוצר הוסף בהצלחה" : "שגיאה, המוצר לא הוסף";
            context.Response.Write(jsonSerializer.Serialize(strResponse));
            return strResponse;
        }

        private static string ProcessProductEdit(HttpContext context, JavaScriptSerializer jsonSerializer, ProductsBL bl, IsoDateTimeConverter dateTimeConverter, string productStr)
        {
            string strResponse;
            Product product = JsonConvert.DeserializeObject<Product>(productStr, dateTimeConverter);
            bool isSuccess = bl.UpdateProduct(product);
            strResponse = (isSuccess) ? "המוצר מעודכן בהצלחה" : "שגיאה, המוצר לא מעודכן";
            context.Response.Write(jsonSerializer.Serialize(strResponse));
            return strResponse;
        }

        private bool UploadFile(HttpContext context, JavaScriptSerializer jsonSerializer)
        {
            bool result;

            //write your handler implementation here.
            if (context.Request.Files.Count <= 0)
            {
                context.Response.Write("No file uploaded");
                result = false;
            }
            else
            {
                for (int i = 0; i < context.Request.Files.Count; ++i)
                {
                    HttpPostedFile file = context.Request.Files[i];
                    file.SaveAs(context.Server.MapPath("/images/" + file.FileName));
                    string successString = "File uploaded successfully";
                    context.Response.Write(jsonSerializer.Serialize(successString));
                    
                }
                result = true;
            }

            return result;
        }

        #endregion

        #region Properties

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        #endregion
    }
}