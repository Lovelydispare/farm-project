import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart',  {
   state: () => {
        const cart= ref([])

        function removeCart(payload) {
            const existingItem = cart.value.findIndex(item => item.id === payload.id)
            if (existingItem) {
             cart.value.splice(existingItem, 1);
            }
        }

        return{
            cart, removeCart
        }
   },
   actions:{
       updateCart(payload) {
           this.cart.push(payload)
           console.log(payload)
       },
   },
   persist: true,
})