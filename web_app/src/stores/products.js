import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import api from '@/services/api'

export const useProductsStore = defineStore('products',  {
   state: () => {
        
        const products = ref([])
        const categories = ref([])
        const selectedProduct = ref(null)
        const error = ref('')
        const loading = ref(false)
       
        async function fetchProducts() {
            const response = await api.get('fetchAllProducts')
            products.value = response.data
        }

        async function fetchCategories() {
            const response = await api.get('fetchAllCategories')
            categories.value = response.data
        }

        async function addProduct(data, token) {
             try {
                await api.post('addProduct', data,
                { 
                    headers: { 
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'multipart/form-data' 
                    } 
                    
                })
                .then(function (response) {
                    error.value = ''
                    loading.value = false
                })
            } catch (err) {
                error.value = err.response?.data?.message || 'Creating product failed'
                throw err
            }
        }

        async function updateProduct(id, data, token) {
             try {
                await api.post('updateProduct'+id, data,
                { 
                    headers: { 
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'multipart/form-data' 
                    } 
                    
                })
                .then(function (response) {
                    error.value = ''
                    loading.value = false
                })
            } catch (err) {
                error.value = err.response?.data?.message || 'Updating product failed'
                throw err
            }
        }

        async function deleteProduct(id, token) {
             try {
                await api.post('deleteProduct'+id,
                { 
                    headers: { 
                        'Authorization': `Bearer ${token}`,
                    } 
                    
                })
                .then(function (response) {
                    error.value = ''
                    loading.value = false
                })
            } catch (err) {
                error.value = err.response?.data?.message || 'Deleting product failed'
                throw err
            }
        }

        return{
            products, fetchProducts, selectedProduct, fetchCategories, updateProduct, deleteProduct, addProduct, categories
        }
   },
   actions:{
        updaeSelectedProduct (payload){
            this.selectedProduct = payload
        }
       
   },
   persist: true,
}) 