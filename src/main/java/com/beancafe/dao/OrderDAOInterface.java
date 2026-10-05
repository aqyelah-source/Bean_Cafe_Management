package com.beancafe.dao;

import com.beancafe.model.Order;
import java.util.List;

public interface OrderDAOInterface {

    // CREATE
    boolean addOrder(Order order);

    // READ - Get all orders
    List<Order> getAllOrders();

    // READ - Get one order
    Order getOrderById(int orderId);

    // UPDATE - Update order status
    boolean updateOrderStatus(int orderId, String status);

    // DELETE / CANCEL
    boolean cancelOrder(int orderId);
}
