using GiftsDal;
using GiftsEntity;

namespace GiftsBL
{
    public class ProductsBL
    {
        #region Fields

        private ProductsDal _dal;

        #endregion

        #region Constructor

        public ProductsBL(string conString)
        {
            _dal = new ProductsDal(conString);
        }

        #endregion

        #region Public methods

        public bool InsertProduct(Product product)
        {
            return _dal.InsertProduct(product);
        }

        public bool UpdateProduct(Product product)
        {
            return _dal.UpdateProduct(product);
        }

        public bool RemoveProduct(int productId)
        {
            return _dal.RemoveProduct(productId);
        }

        public ProductData GetProductsData(int page, int rowsOnPage)
        {
            ProductData data = _dal.GetTotalProductsData(rowsOnPage);
            data.ProductsList = _dal.GetProductsList(page, rowsOnPage);
            // public List<Product> GetProductsList(int page, int rowsOnPage)
            return data;
        }

        #endregion
    }
}
