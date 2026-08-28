import { ref } from 'vue'
import api  from './api';

export function useAuth() {
    const isAuthenticated = ref(false)
    const isAdmin = ref(false)
    const error = ref('')
    const loading = ref(false)
    const user = ref(null)

    // Login
    async function checkCredentials(credentials) {

        try {

            if (!credentials.email || !credentials.password) {
                throw new Error('Email and password are required')
            }
            
            const response = await api.post('login', credentials)
            const { token, user: userData } = response.data


            if (token && userData) {
                user.value = userData

                if (user.value.role == 1) isAdmin.value = true
                isAuthenticated.value = true

                localStorage.setItem("authToken", token);
                localStorage.setItem("user", JSON.stringify(user.value));
                localStorage.setItem("isAdmin", isAdmin.value);
                localStorage.setItem("isAuthenticated", isAuthenticated.value);

                return response
            } else {
                throw new Error('Invalid response format from server')
            }

        } catch (err) {
            error.value = err.response?.data?.message || err.message || 'Login failed'
            throw err
        } finally {
            loading.value = false
        }
    }

    // Register
    async function signup(data) {

        loading.value = true
        error.value = null

        console.log(formData)
        try {
             const response = await api.post('register', formData)
             const { token, user: userData } = response.data
            if (token && userData) {
                user.value = userData
                localStorage.setItem("authToken", token);
                localStorage.setItem("user", JSON.stringify(user));

                return response
            } else {
                throw new Error('Invalid response format from server')
            }
        } catch (err) {
            error.value = err.response?.data?.message || 'Registration failed'
            throw err
        } finally {
            loading.value = false
        }
    }

    // Logout
    function logout() {
        localStorage.removeItem("isAuthenticated");
        localStorage.removeItem("user");
        localStorage.removeItem("isAdmin");
        localStorage.removeItem("authToken");
    }
    return {
        checkCredentials,
        signup,
        logout,
    }
 }