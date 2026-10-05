package com.beancafe.dao;

import com.beancafe.model.Menu;
import java.util.List;

public interface MenuDAOInterface {

    boolean addMenu(Menu menu);

    List<Menu> getAllMenu();

    Menu getMenuById(int menuId);

    boolean updateMenu(Menu menu);

    boolean deleteMenu(int menuId);
}
