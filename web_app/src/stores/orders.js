import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import api from '@/services/api'

export const useOrdersStore = defineStore('orders',  {
   state: () => {
        const orders= ref([])

        async function fetchAllOrders(token){
            const response = await api.get('fetchAllOrders',
                {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                    }
                }
            )
            orders.value = response.data
        }

        async function completeOrder(id, token){
            const response = await api.post('completeOrder/'+id, null,
                {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                    }
                }
            )
           // orders.value = response.data
        }

        return{
            orders, fetchAllOrders, completeOrder
        }
   },
   actions:{
        checkout(payload) {
            //get the last key in the object
            const existingKeys = Object.keys(this.orders).map(Number);
            const maxKey = existingKeys.length > 0 ? Math.max(...existingKeys) : 0;
            const nextKey = maxKey + 1;
            
            // Loop through each item in the cart object
            Object.values(payload).forEach((cartItem) => {
                
                const calculatedTotalPaid = Number(cartItem.price) * Number(cartItem.quantity)

                const newOrder = {
                id: nextKey,
                customer_id: 4, //to do: get id from user data
                product_id: cartItem.id,       
                quantity: cartItem.quantity,
                total_paid: calculatedTotalPaid, 
                status: "processing"           
                }

                this.orders[nextKey] = {
                ...newOrder,
                id: nextKey
            };
            })
            
        },
    
    
   },
   persist: true,
})