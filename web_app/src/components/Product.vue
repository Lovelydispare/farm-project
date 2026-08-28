<script setup>
import {ref, computed, onMounted} from 'vue'
import { storeToRefs } from 'pinia'
import { useProductsStore } from '../stores/products'
import { useCartStore } from '../stores/cart'
import { useOrdersStore } from '../stores/orders'
import { useRouter } from 'vue-router'

const router = useRouter()
const productsStore = useProductsStore()
const ordersStore = useOrdersStore()

const { products }= storeToRefs(productsStore)
const isAuthenticated = localStorage.getItem('isAuthenticated')

function view(product){
   productsStore.updateSelectedProduct(product) // keep track of the selected item
    router.push('/product_detail')
}

//cart
const cartStore = useCartStore()
const cart = cartStore.cart
const dialog = ref(false)

const quantity = ref(1)
const total = ref(0)

function addToCart(product){
    if (isAuthenticated) {
        product.quantity = quantity.value
        cartStore.updateCart(product)
    }
    else{
        router.push('/login')
    }
}
function checkout(){
    if (isAuthenticated) {
        ordersStore.checkout(cart)
        console.log('here')
    }
    else{
        router.push('/login')
    }
    
}
const cartTotal = computed(() => {
  return cart.reduce((sum, item) => {
    const qty = Number(item.quantity || 0)
    const price = Number(item.price || 0)
    return sum + (price * qty)
  }, 0)
})
const handleRemove = (productId) => {
  cartStore.removeCart(productId)
}

onMounted(async() => {
    await productsStore.fetchProducts()
})

</script>

<template>
    <v-container max-width="100%">
        <v-row class="mb-12 mt-12">
            <v-col>
                <div class="text-display-small">
                    Browse products
                </div>
            </v-col>
            <v-col align="right">
                <v-fab-transition>
                    <v-btn color="primary" position="fixed" style="z-index: 9999; top: 100px; right: 50px" class="me-4 mt-4" @click="dialog = true" >Checkout</v-btn>
                </v-fab-transition>
            </v-col>
            <v-divider/>
        </v-row>
        <v-row>
            <v-col v-for="product in products">
                <v-card class="h-100 d-flex flex-column" width="250">
                    <v-img :src="product.image" height="200px" class="mt-4"></v-img>
                    <v-card-title class="overflow-y-auto">{{ product.name }}</v-card-title>
                    <v-card-subtitle>{{ product.price }}</v-card-subtitle>
                    <v-card-text>{{ product.description }}</v-card-text>
                    <v-card-actions>
                        <v-btn color="primary" variant="elevated" @click="addToCart(product)">Add to Cart</v-btn>
                        <v-btn color="primary" variant="elevated" @click="view(product)">View</v-btn>
                    </v-card-actions>
                </v-card>
            </v-col>
        </v-row>
    </v-container>

    <!-- Checkout -->
     <v-dialog v-model="dialog" max-width="600">
        <div v-if="cart.length == 0" class="mt-12">
            <v-card>
                <v-row class="mb-12 mt-12">
                    <v-col cols="12" md="10" sm="12" align="center">
                        <div class="text-display-small">
                            Your cart is empty!
                        </div>
                    </v-col>
                    <v-col cols="12" md="2" sm="12" align="right">
                        <v-btn class="ma-2" color="primary" icon="mdi-close" @click="dialog = false"></v-btn>
                    </v-col>
                </v-row>
            </v-card>
        </div>
        <div v-else>
        <v-row>
            <v-col md="12">
                <v-card>
                    <v-row class="ma-4">
                        <v-col cols="12" md="10" sm="12">
                            <v-card-title>Cart</v-card-title>
                        </v-col>
                        <v-col cols="12" md="2" sm="12" align="right">
                            <v-btn color="primary" icon="mdi-close" @click="dialog = false"></v-btn>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-divider/>
                        <v-expansion-panels :rounded="[20, 8]" gap="8" variant="accordion" class="ma-4" >
                            <v-expansion-panel v-for="(item, index) in cart" :key="item.id" color="secondary">
                                <v-expansion-panel-title expand-icon="mdi-menu-down">{{ item.name }}</v-expansion-panel-title>
                                <v-expansion-panel-text> Price: {{item.price}} </v-expansion-panel-text>
                                <v-expansion-panel-text>
                                    <v-row>
                                    <v-col md="3">
                                        <v-select v-model="cart[index].quantity" :items="[1,2,3,4,5]" label="Qty" density="compact" variant="outlined" hide-details ></v-select>
                                    </v-col>
                                    <v-col>
                                        Subtotal: {{ (item.price * (item.quantity || 0)).toFixed(2)}}
                                    </v-col>
                                     <v-col cols="2" class="text-center">
                                        <v-btn icon="mdi-trash-can-outline" variant="text" color="error" density="comfortable" @click="handleRemove(item.id)" ></v-btn>
                                    </v-col>
                                    </v-row>
                                </v-expansion-panel-text>
                            </v-expansion-panel>
                        </v-expansion-panels>
                    </v-row>
                    <v-card-actions>
                        <div>
                            <span class="mr-2">Total Amount:</span>
                            <span class="text-h5 font-weight-bold text-primary">Ksh {{ cartTotal.toFixed(2) }}</span>
                        </div>
                        <v-spacer/>
                        <v-btn variant="elevated" @click="checkout">Pay via MPesa</v-btn>
                    </v-card-actions>
                </v-card>
            </v-col>
        </v-row>
        </div>
    </v-dialog>
</template>