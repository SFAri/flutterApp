import createError from "http-errors";
import { ProductService, AddressService } from "../../core/services/index.js";
// import { upload } from "../middlewares/index.js";
import { CheckMissingFields, FormatResult } from "../../utils/index.js";

class ProductController {
  async createProduct(req, res, next) {
    try {
      const { name, brand, description, category, images, variants, discount } =
        req.body;

      CheckMissingFields({
        name,
        brand,
        description,
        category,
        images,
        variants,
      });

      const newProduct = {
        name,
        brand,
        description,
        category,
        images,
        variants,
        discount,
      };

      const data = await ProductService.AddNewProduct(newProduct);
      res.status(201).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getProductDetail(req, res, next) {
    const id = req.params.id;

    try {
      const data = await ProductService.GetProductById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getListProduct(req, res, next) {
    try {
      const data = await ProductService.GetListProduct();
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getFilterProduct(req, res, next) {
    const { searchText, page, limit, sortBy, filter } = req.body || {};
    const pageQuery = parseInt(page) || null;
    const perPage = parseInt(limit) || null;

    try {
      const data = await ProductService.GetProductByFilter(
        filter,
        sortBy,
        searchText,
        pageQuery,
        perPage
      );
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async updateProduct(req, res, next) {
    const id = req.params.id;

    try {
      const updatedProduct = req.body;
      const data = await ProductService.UpdateProductById(id, updatedProduct);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async deleteProduct(req, res, next) {
    const id = req.params.id;

    try {
      const data = await ProductService.DeleteProductById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }
}

export default new ProductController();
