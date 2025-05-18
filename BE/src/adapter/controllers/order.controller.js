import createError from "http-errors";
import { OrderService } from "../../core/services/index.js";
import { CheckMissingFields, FormatResult } from "../../utils/index.js";

class OrderController {
  async createOrder(req, res, next) {
    const { _id } = req.user;

    try {
      const { cartItems, couponCode, shippingAddressId, paymentMethod } =
        req.body;

      CheckMissingFields({
        cartItems,
        shippingAddressId,
        paymentMethod,
      });

      const newOrder = {
        userId: _id,
        cartItems,
        couponCode,
        shippingAddressId,
        paymentMethod,
      };

      const data = await OrderService.CreateOrder(newOrder);
      res.status(201).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getOrderDetail(req, res, next) {
    const id = req.params.id;
    try {
      const data = await OrderService.GetOrderById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getOrdersByUser(req, res, next) {
    const userId = req.user._id;
    try {
      const data = await OrderService.GetOrdersByUserId(userId);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getListOrder(req, res, next) {
    try {
      const data = await OrderService.GetAllOrders();
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getFilterOrder(req, res, next) {
    const { page, limit, sortBy, filter } = req.body || {};
    const pageQuery = parseInt(page) || null;
    const perPage = parseInt(limit) || null;

    try {
      const data = await OrderService.GetOrderByFilter(
        filter,
        sortBy,
        pageQuery,
        perPage
      );
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async updateOrderStatus(req, res, next) {
    const id = req.params.id;
    const status = req.body.status;

    try {
      const data = await OrderService.UpdateOrderStatus(id, status);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async deleteOrder(req, res, next) {
    const id = req.params.id;

    try {
      const data = await OrderService.DeleteOrderById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }
}

export default new OrderController();
