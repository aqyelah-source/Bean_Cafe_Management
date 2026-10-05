<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Bean Cafe Management System</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f0eb; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 32px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 320px; }
        h2 { text-align: center; color: #4b2e1e; margin-bottom: 20px; }
        label { display: block; margin-bottom: 6px; color: #333; font-size: 14px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; margin-bottom: 16px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .password-wrapper { position: relative; }
        .password-wrapper input { padding-right: 40px; }
        .toggle-password { position: absolute; right: 10px; top: 8px; cursor: pointer; user-select: none; font-size: 16px; color: #666; background: none; border: none; padding: 0; }
        /* Hide Edge's own built-in reveal/clear icons so only our custom icon shows, consistent across browsers */
        input[type="password"]::-ms-reveal,
        input[type="password"]::-ms-clear { display: none; }
        button[type="submit"] { width: 100%; padding: 10px; background: #6f4e37; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        button[type="submit"]:hover { background: #593e2c; }
        .error { color: #c0392b; text-align: center; margin-bottom: 12px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Bean Cafe Login</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <form action="LoginServlet" method="post" autocomplete="off">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required autocomplete="off"
                   readonly onfocus="this.removeAttribute('readonly');" />

            <label for="password">Password</label>
            <div class="password-wrapper">
                <input type="password" id="password" name="password" required autocomplete="new-password"
                       readonly onfocus="this.removeAttribute('readonly');" />
                <button type="button" class="toggle-password" onclick="togglePassword()" aria-label="Show or hide password">&#128065;</button>
            </div>

            <button type="submit">Login</button>
        </form>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
        }
    </script>
</body>
</html>