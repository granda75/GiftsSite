using GiftsBL;
using GiftsDal;
using GiftsEntity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace GiftsSite
{
    /// <summary>
    /// Summary description for JQGridHandler
    /// </summary>
    public class JQGridHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string conString = ConfigurationManager.ConnectionStrings["GiftsDB"].ConnectionString;
            NameValueCollection forms = context.Request.Form;
            string strOperation = forms.Get("oper");
            //string page2 = context.Request.QueryString["page"];

            string queryString = HttpUtility.UrlDecode(context.Request.QueryString.ToString());
            GridPageData pageData = JsonConvert.DeserializeObject<GridPageData>(queryString);

            string strResponse = string.Empty;
            var jsonSerializer = new JavaScriptSerializer();
            ProductsBL bl = new ProductsBL(conString);

            if (strOperation == null)
            {
                string parameters = HttpUtility.UrlDecode(context.Request.Params.ToString());
                string[] parts = parameters.Split('}');
                if (parts != null && parts.Length > 0)
                {
                    string productStr = parts[0] + "}";
                    if (!string.IsNullOrEmpty(productStr) && productStr.Contains("edit"))
                    {
                        strOperation = "edit";
                        Product product = JsonConvert.DeserializeObject<Product>(productStr);
                        bl.UpdateProduct(product);
                    }
                    else if (productStr.Contains("add"))
                    {
                        Product product = JsonConvert.DeserializeObject<Product>(productStr);
                        bl.InsertProduct(product);
                    }
                }

            if ( strOperation == null )
            {
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
                int productId = Int32.Parse(forms.Get("Id"));
                bool isSuccess = bl.RemoveProduct(productId);
                strResponse = (isSuccess) ? "המוצר נמחק בהצלחה" : "שגיאה, המוצר לא נמחק";
                context.Response.Write(strResponse);
            }
            //else
            //{
            //    //string parameters = HttpUtility.UrlDecode(context.Request.Params.ToString()); 
            //    //string[] parts = parameters.Split('}');
            //    if (parts != null && parts.Length > 0)
            //    {
            //        string productStr = parts[0] + "}";
            //        if ( !string.IsNullOrEmpty(productStr) && productStr.Contains("edit"))
            //        { 
            //            Product product = JsonConvert.DeserializeObject<Product>(productStr);
            //            bl.UpdateProduct(product);
            //        }
            //        else if (productStr.Contains("add"))
            //        {
            //            Product product = JsonConvert.DeserializeObject<Product>(productStr);
            //            bl.InsertProduct(product);
            //        }
            //    }
                
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}