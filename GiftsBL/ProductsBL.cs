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
