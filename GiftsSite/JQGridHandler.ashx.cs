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

            if ( strOperation == null )
            {
                //oper = null which means its first load.
                ProductsBL bl = new ProductsBL(conString);
                ProductData productsData = bl.GetProductsData(pageData.page, pageData.rows);

                var jsonData = new
                {
                    total = productsData.TotalPages,
                    page = pageData.page,
                    records = productsData.TotalRows,
                    rows = productsData.ProductsList
                };

                var jsonSerializer = new JavaScriptSerializer();
                context.Response.Write(jsonSerializer.Serialize(jsonData));
            }
            //else if (strOperation == "del")
            //{
            //    var query = Query.EQ("_id", forms.Get("EmpId").ToString());
            //    collectionEmployee.Remove(query);
            //    strResponse = "Employee record successfully removed";
            //    context.Response.Write(strResponse);
            //}
            //else
            //{
            //    string strOut = string.Empty;
            //    AddEdit(forms, collectionEmployee, out strOut);
            //    context.Response.Write(strOut);
            //}
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