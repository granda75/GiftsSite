
using GiftsEntity;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace GiftsDal
{
    public class ProductsDal
    {
        #region Fields

        private string _conString;

        #endregion

        #region Constructors

        public ProductsDal(string conString)
        {
            _conString = conString;
        }

        #endregion

        #region Public methods

        public bool InsertProduct(Product product)
        {
            int numberOfAffectedRows = 0;
            bool isSucceess = false;

            using (SqlConnection connection = new SqlConnection(_conString))
            {
                connection.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[InsertProduct]", connection);
                cmd.Parameters.Add(new SqlParameter("@p_productName", product.ProductName));
                cmd.Parameters.Add(new SqlParameter("@p_description", product.Description));
                cmd.Parameters.Add(new SqlParameter("@p_saleDate", product.SaleDate));
                cmd.Parameters.Add(new SqlParameter("@p_imageFileName", product.ImageFileName));

                cmd.CommandType = CommandType.StoredProcedure;
                numberOfAffectedRows = (int)cmd.ExecuteNonQuery();
            }

            isSucceess = (numberOfAffectedRows > 0) ? true : false;
            return isSucceess;
        }

        public bool UpdateProduct(Product product)
        {
            int numberOfAffectedRows = 0;
            bool isSucceess = false;

            using (SqlConnection connection = new SqlConnection(_conString))
            {
                connection.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[UpdateProduct]", connection);
                cmd.Parameters.Add(new SqlParameter("@p_Id", product.Id));
                cmd.Parameters.Add(new SqlParameter("@p_productName", product.ProductName));
                cmd.Parameters.Add(new SqlParameter("@p_description", product.Description));
                cmd.Parameters.Add(new SqlParameter("@p_saleDate", product.SaleDate));
                cmd.Parameters.Add(new SqlParameter("@p_imageFileName", product.ImageFileName));

                cmd.CommandType = CommandType.StoredProcedure;
                numberOfAffectedRows = (int)cmd.ExecuteNonQuery();
            }

            isSucceess = (numberOfAffectedRows > 0) ? true : false;
            return isSucceess;
        }

        public bool RemoveProduct(int productId)
        {
            int numberOfAffectedRows = 0;
            bool isSucceess = false;

            using (SqlConnection connection = new SqlConnection(_conString))
            {
                connection.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[RemoveProduct]", connection);
                cmd.Parameters.Add(new SqlParameter("@productId", productId));
                cmd.CommandType = CommandType.StoredProcedure;
                numberOfAffectedRows = (int)cmd.ExecuteNonQuery();
            }

            isSucceess = (numberOfAffectedRows > 0) ? true : false;
            return isSucceess;
        }

        public ProductData GetTotalProductsData(int rowsOnPage)
        {
            ProductData data = new ProductData();
            
            using (SqlConnection connection = new SqlConnection(_conString))
            {
                connection.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[GetProductsTotalCount]", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                data.TotalRows = (int) cmd.ExecuteScalar();
                data.TotalPages = (data.TotalRows + rowsOnPage - 1) / rowsOnPage;
            }
            return data;
        }

        public List<Product> GetProductsList(int page, int rowsOnPage)
        {
            DataSet ds = new DataSet();
            using (SqlConnection connection = new SqlConnection(_conString))
            {
                SqlDataAdapter adapter = new SqlDataAdapter();
                SqlCommand cmd = new SqlCommand("[dbo].[GetProductsForPage]", connection);
                cmd.Parameters.Add(new SqlParameter("@pageNumber", page));
                cmd.Parameters.Add(new SqlParameter("@rowsOfPage", rowsOnPage));
                cmd.CommandType = CommandType.StoredProcedure;
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                List<Product> productsList = ds.Tables[0].ToIEnumerable<Product>().ToList();
                return productsList;
            }
        }

        #endregion
    }

}

