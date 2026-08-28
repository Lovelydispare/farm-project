<script setup>
import {ref, computed} from 'vue'
import { useProductsStore } from '../stores/products'
import { useUsersStore } from '../stores/users'
import { useOrdersStore } from '../stores/orders'

const productsStore = useProductsStore()
const usersStore = useUsersStore()
const ordersStore = useOrdersStore()

const products= productsStore.products
const users = usersStore.users
const orders = ordersStore.orders

const allOrders = Object.values(orders).map(order => { 
    const product = Object.values(products).find(product => product.id === order.product_id);
    const user = Object.values(users).find(user => user.id === order.customer_id);
    return {
        ...order,
        customer: user ? user.firstname + ' '+  user.lastname: 'Unknown User',
        productName: product ? product.name : 'Unknown Product',
        price: product ? product.price : '0'
        
    };
});

const tab = ref(null)
const refreshKey = ref(0)
const showAddProductDialog = ref(false)
const showEditProductDialog = ref(false)
const viewOrderDialog = ref(false)

//products
// product models
const productId = ref(null)
const productName = ref(null)
const price = ref(null)
const availability = ref(null)
const category = ref(null)
const image = ref(null)

//add new product
function handleAddProduct(){
    const data = {
        productId: productId.value,
        name: productName.value,
        price: price.value,
        availability: true,
        category: category.value,
        image: image.value,
    }
    //update products in the store
     productsStore.addProduct(data)
     close()
}

//edit product
function editProduct(product){
    productId.value = product.id
    productName.value = product.name
    price.value = product.price
    availability.value = product.availability
    category.value = product.category
    image.value = product.image
    showEditProductDialog.value = true
}
function handleUpdateProduct(){
    const data = {
        productId: productId.value,
        name: productName.value,
        price: price.value,
        availability: availability.value,
        category: category.value,
        image: image.value,
    }

    //to do update product
    productsStore.updateProduct(productId.value, data)
    close()
    refreshKey.value += 1    

}
//delete
function handleDeleteProduct(id){
    productsStore.deleteProduct(id);
    refreshKey.value += 1
}

//orders

const orderCustomerName = ref(null)
const orderCustomerAddress = ref(null)
const orderProductName = ref(null)
const orderPrice = ref(null)
const orderQuantity = ref(null)
const orderTotalPaid = ref(null)
const orderStatus = ref(null)
const subtotal =ref(null)
const totalAmount =ref(null)

function viewOrder(item){
    orderCustomerName.value = item.customer
    orderCustomerAddress.value = item.customerName
    orderProductName.value = item.productName
    orderPrice.value = item.price
    orderQuantity.value = item.quantity
    orderTotalPaid.value = item.total_paid
    orderStatus.value = item.status

    subtotal.value = computed(() => item.price * item.quantity)
    totalAmount.value = computed(() => subtotal.value)
    viewOrderDialog.value = true

}

function handleCompleteOrder(id){
    ordersStore.completeOrder(id)
    refreshKey.value += 1    
    close()
}

function close(){
    //product
    productId.value = null
    productName.value = null
    price.value = null
    availability.value = null
    category.value = null
    image.value = null
    showAddProductDialog.value = false
    showEditProductDialog.value = false 

    //order
    orderCustomerName.value = null
    orderCustomerAddress.value = null
    orderProductName.value = null
    orderPrice.value = null
    orderQuantity.value = null
    orderTotalPaid.value = null
    orderStatus.value = null
    viewOrderDialog.value = false
}

</script>

<template>
    <v-container class=" mt-12 bg-secondary" :key="refreshKey">
        <v-card>
            <v-tabs v-model="tab" align-tabs="center" color="primary" >
                <v-tab :value="1">Products</v-tab>
                <v-tab :value="2">Orders</v-tab>
            </v-tabs>

            <v-tabs-window v-model="tab">
                <!-- Products -->
                <v-tabs-window-item :value="1">
                    <div v-if="products == null||products==undefined||Object.keys(products).length == 0" align="center">
                        <v-row>
                            <v-col cols="12" md="6" sm="12" >
                                <div class="text-h6">No products found</div>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" >
                                <v-btn class="ma-2" color="blue-darken-2" icon="mdi-plus" @click="showAddProductDialog = true"></v-btn>
                            </v-col>
                        </v-row>
                    </div>
                    <div v-else>
                        <v-container>
                            <v-row>
                                <v-col cols="12" md="12" sm="12" align="right">
                                    <v-btn class="ma-2" color="blue-darken-2" icon="mdi-plus" @click="showAddProductDialog = true"></v-btn>
                                </v-col>
                            </v-row>
                        <v-row>
                        <v-col>
                            <v-table class="border">
                                <thead>
                                    <tr>
                                        <th class="text-left"> Name </th>
                                        <th class="text-left"> Price </th>
                                        <th class="text-left"> Category </th>
                                        <th class="text-left"> Status </th>
                                        <th class="text-center" colspan="3"> Action </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in products" :key="item.id" >
                                        <td>{{ item.name }}</td>
                                        <td>{{ item.price }}</td>
                                        <td>{{ item.category }}</td>
                                        <td>{{ item.availability }}</td>
                                        <td> <v-btn color="warning" size="small"><v-icon icon="mdi-eye" ></v-icon> View</v-btn> </td>
                                        <td> <v-btn color="blue" size="small" @click="editProduct(item)"><v-icon icon="mdi-pencil" ></v-icon> Edit</v-btn> </td>
                                        <td> <v-btn color="error" size="small" @click="handleDeleteProduct(item.id)"><v-icon icon="mdi-delete"></v-icon> Delete</v-btn> </td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </v-col>
                    </v-row>
                        </v-container>
                    </div>
                </v-tabs-window-item>
               
                <!-- Orders -->
                <v-tabs-window-item :value="2">
                    <div v-if="orders == null||orders==undefined||Object.keys(orders).length == 0" align="center">
                        <v-row>
                            <v-col cols="12" md="6" sm="12" >
                                <div class="text-h6">No orders found</div>
                            </v-col>
                        </v-row>
                    </div>
                    <div v-else>
                        <v-container>
                            <v-row>
                            </v-row>
                        <v-row>
                        <v-col>
                            <v-table class="border">
                                <thead>
                                    <tr>
                                        <th class="text-left"> Customer </th>
                                        <th class="text-left"> Product </th>
                                        <th class="text-left"> Price </th>
                                        <th class="text-left"> Quantity </th>
                                        <th class="text-left"> Total </th>
                                        <th class="text-left"> Status </th>
                                        <th class="text-center" colspan="3"> Action </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in allOrders" :key="item.id" >
                                        <td>{{ item.customer }}</td>
                                        <td>{{ item.productName }}</td>
                                        <td>{{ item.price }}</td>
                                        <td>{{ item.quantity }}</td>
                                        <td>{{ item.total_paid }}</td>
                                        <td>{{ item.status }}</td>
                                        <td> <v-btn color="warning" size="small" @click="viewOrder(item)"><v-icon icon="mdi-eye"></v-icon> View</v-btn> </td>
                                        <td v-if="item.status != 'fulfilled'"> <v-btn color="blue" size="small" @click="handleCompleteOrder(item.id)"><v-icon icon="mdi-progress-check" ></v-icon> Complete Order</v-btn> </td>
                                        <td v-else> <v-btn color="blue" size="small" disabled><v-icon icon="mdi-check-circle" ></v-icon> Completed</v-btn> </td>
                                        <td> <v-btn color="error" size="small"><v-icon icon="mdi-delete" ></v-icon> Delete</v-btn> </td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </v-col>
                    </v-row>
                        </v-container>
                    </div>
                </v-tabs-window-item>
            </v-tabs-window>
        </v-card>
    </v-container>
    <!-- Dialogs -->
    <!-- Product Dialog -->
    <!-- Add Product -->
    <v-dialog v-model="showAddProductDialog" max-width="600">
        <v-form @submit.prevent >
            <v-card>
                <v-card-title class="pa-6">
                <v-row>
                        Add Product
                        <v-spacer></v-spacer>
                        <v-btn class="ma-2" color="blue-darken-2" icon="mdi-close" @click="close();"></v-btn>
                    </v-row>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="Product Name" v-model="productName" required></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-select :items="['Fruit', 'Vegetable', 'Cereals']" v-model ="category">
                            </v-select>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="Image" v-model="image" required></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-text-field label="Price" v-model="price" required></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text="Close" variant="plain" @click="close()" ></v-btn>
                    <v-btn color="primary"  text="Save" variant="tonal" @click="handleAddProduct()" ></v-btn>
                </v-card-actions>
            </v-card>
        </v-form>
    </v-dialog>

    <!-- Edit Product -->
    <v-dialog v-model="showEditProductDialog" max-width="600">
        <v-form @submit.prevent >
            <v-card>
                <v-card-title class="pa-6">
                <v-row>
                        Edit Product
                        <v-spacer></v-spacer>
                        <v-btn class="ma-2" color="blue-darken-2" icon="mdi-close" @click="close();"></v-btn>
                    </v-row>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="Product Name" v-model="productName" required></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-select :items="['Fruit', 'Vegetable', 'Cereals']" v-model ="category">
                            </v-select>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="Image" v-model="image" required></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-text-field label="Price" v-model="price" required></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-radio-group v-model="availability" inline>
                                <v-radio label="In Stock" value="true"></v-radio>
                                <v-radio label="Out Of Stock" value="false"></v-radio>
                            </v-radio-group>
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text="Close" variant="plain" @click="close()" ></v-btn>
                    <v-btn color="primary"  text="Update" variant="tonal" @click="handleUpdateProduct()" ></v-btn>
                </v-card-actions>
            </v-card>
        </v-form>
    </v-dialog>

    <!-- Order -->
    <v-dialog v-model="viewOrderDialog" max-width="600">
        <v-card elevation="3" rounded="lg">
            <!-- Card Header with Order Status -->
            <v-card-item class="bg-grey-lighten-4 py-4">
            <div class="d-flex justify-space-between align-center">
                <div>
                <v-card-subtitle class="text-overline mb-1">ORDER DETAILS</v-card-subtitle>
                <v-card-title class="text-h6 font-weight-bold">#ORD-94820</v-card-title>
                </div>
                <!-- Order Status Chip -->
                <v-chip
                :color="orderStatus == 'fulfilled' ? 'success' : 'warning'"
                :prepend-icon="orderStatus=='fulfilled' ? 'mdi-check-circle' : 'mdi-clock-outline'"
                size="small"
                class="text-uppercase font-weight-bold"
                >
                {{ orderStatus=='fulfilled'  ? 'Complete' : 'Pending' }}
                </v-chip>
            </div>
            </v-card-item>

            <v-divider></v-divider>

            <!-- Customer Information Section -->
            <v-card-text class="pt-4">
            <div class="text-subtitle-2 text-medium-emphasis mb-1">Customer</div>
            <div class="text-body-1 font-weight-medium mb-3">{{ orderCustomerName }}</div>

            <div class="text-subtitle-2 text-medium-emphasis mb-1">Shipping Address</div>
            <div class="text-body-2 text-high-emphasis line-height-xl mb-1">
                {{ orderCustomerAddress }}
            </div>
            </v-card-text>

            <v-divider class="mx-4"></v-divider>

            <!-- Product Line Items Section -->
            <v-card-text class="py-2">
            <div class="text-subtitle-2 text-medium-emphasis mb-2">Items</div>
            <v-list class="pa-0" density="compact">
                <v-list-item class="px-0 py-1">
                <div class="d-flex justify-space-between align-start w-100">
                    <div>
                    <div class="text-body-1 font-weight-medium">{{ orderProductName }}</div>
                    <div class="text-caption text-medium-emphasis">
                        {{ orderQuantity }} × ${{ orderPrice.toFixed(2) }}
                    </div>
                    </div>
                    <div class="text-body-1 font-weight-medium text-right">
                    ${{ subtotal }}
                    </div>
                </div>
                </v-list-item>
            </v-list>
            </v-card-text>

            <v-divider class="mx-4"></v-divider>

            <!-- Order Financial Totals Section -->
            <v-card-text class="pb-6">
            <div class="d-flex justify-space-between mb-2">
                <span class="text-body-2 text-medium-emphasis">Subtotal</span>
                <span class="text-body-2">${{ subtotal }}</span>
            </div>
            <div class="d-flex justify-space-between mb-4">
                <span class="text-body-2 text-medium-emphasis">Delivery Fee</span>
                <span class="text-body-2">200</span>
            </div>
            <div class="d-flex justify-space-between align-center pt-2 border-top">
                <span class="text-subtitle-1 font-weight-bold">Total Amount</span>
                <span class="text-h6 font-weight-bold text-primary">${{ totalAmount }}</span>
            </div>
            </v-card-text>
        </v-card>
    </v-dialog>
</template>