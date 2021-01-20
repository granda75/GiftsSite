using GiftsDal;
using GiftsEntity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web.UI;


namespace GiftsSite
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //string conString = ConfigurationManager.ConnectionStrings["GiftsDB"].ConnectionString;
            //ProductsDal dal = new ProductsDal(conString);
            //DataSet productsDs = dal.GetProductsData(1, 2);
            //productsGrid.DataSource = productsDs;
            //productsGrid.DataBind();
        }

        public List<Product> GetProductsData()
        {
            string conString = ConfigurationManager.ConnectionStrings["GiftsDB"].ConnectionString;
            ProductsDal dal = new ProductsDal(conString);
            List<Product> productsLst = dal.GetProductsList(1, 2);
            return productsLst;
        }
    }
}