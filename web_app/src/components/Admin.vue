<script setup>
import { ref, computed, onMounted } from 'vue'
import { useProductsStore } from '../stores/products'
import { useUsersStore } from '../stores/users'
import { useOrdersStore } from '../stores/orders'
import { storeToRefs } from 'pinia'

const productsStore = useProductsStore()
const usersStore = useUsersStore()
const ordersStore = useOrdersStore()

const { products, categories } = storeToRefs(productsStore)
const { orders } = storeToRefs(ordersStore)
const users = usersStore.users
const token = localStorage.getItem("authToken")

const tab = ref(null)
const refreshKey = ref(0)
const showAddProductDialog = ref(false)
const showEditProductDialog = ref(false)
const showAddUserDialog = ref(false)
const showEditUserDialog = ref(false)
const viewOrderDialog = ref(false)

//image
const selectedFile = ref(null);
const previewUrl = ref(null);

// Capture selected file and create local preview
const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (!file) return;

  selectedFile.value = file;
  
  // Creates a temporary local browser preview string URL
  previewUrl.value = URL.createObjectURL(file);
};

//products
// product models
const productId = ref(null)
const productName = ref(null)
const price = ref(null)
const availability = ref(null)
const category = ref(null)
const image = ref(null)
const description = ref(null)

//add new product
async function handleAddProduct(){
   const formData = new FormData();
    formData.append('image', image.value)
    formData.append('name', productName.value)
    formData.append('price', price.value)
    formData.append('category_id', category.value)
    formData.append('description', description.value)

    //update products in the store
     await productsStore.addProduct(formData, token)
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
    previewUrl.value = product.image
    description.value = product.description
    showEditProductDialog.value = true
}
async function handleUpdateProduct(){
    const formData = new FormData();
    formData.append('image', image.value)
    formData.append('name', productName.value)
    formData.append('price', price.value)
    formData.append('category_id', category.value)
    formData.append('description', description.value)
    formData.append('availability', availability.value)

    //to do update product
    await productsStore.updateProduct(productId.value,formData,token)
    close()
    refreshKey.value += 1    

}
//delete
async function handleDeleteProduct(id){
   await productsStore.deleteProduct(id, token);
    refreshKey.value += 1
}

//user models
const userId = ref(null)
const firstname = ref(null)
const lastname = ref(null)
const email = ref(null)
const phone = ref(null)
const location = ref(null)
const address = ref(null)

//add user
function addUser(){
    const data = {
        userId: userId.value,
        firstname: firstname.value,
        lastname: lastname.value,
        email: email.value,
        phone: phone.value,
        location: location.value,
        address: address.value,
        password: "qwerty1234..",
        role: 2,
    }
    //add user
    usersStore.addUser(data)
    close()
}

//edit user
function editUser(user){
    userId.value = user.id
    firstname.value = user.firstname
    lastname.value = user.lastname
    email.value = user.email
    phone.value = user.phone
    location.value = user.location
    address.value = user.address
    showEditUserDialog.value = true
}

//update user
function updateUser(){
    const data = {
        userId: userId.value,
        firstname: firstname.value,
        lastname: lastname.value,
        email: email.value,
        phone: phone.value,
        location: location.value,
        address: address.value,
        password: "qwerty1234..",
        role: 2,
    }
    //edit user
    usersStore.editUser(userId.value, data)
    refreshKey.value += 1    
    close()
}

//delete user
function destroyUser(id){
    usersStore.deleteUser(id);
    refreshKey.value += 1
}

//orders
//1. view order details - user details, product details, total
//2. complete order

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

async function handleCompleteOrder(id){
   await ordersStore.completeOrder(id, token)
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

    //user
    userId.value = null
    firstname.value = null
    lastname.value = null
    email.value = null
    phone.value = null
    location.value = null
    address.value = null
    showAddUserDialog.value = false
    showEditUserDialog.value = false

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
onMounted(async() =>{
    await productsStore.fetchProducts()
    await productsStore.fetchCategories()
    await ordersStore.fetchAllOrders(token)
})

</script>

<template>
    <v-container class=" mt-12 bg-secondary" :key="refreshKey">
        <v-card>
            <v-tabs v-model="tab" align-tabs="center" color="primary" >
                <v-tab :value="1">Products</v-tab>
                <v-tab :value="2">Users</v-tab>
                <v-tab :value="3">Orders</v-tab>
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
                                        <td>{{ item.category.name }}</td>
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
               
                <!-- Users -->
                <v-tabs-window-item :value="2">
                    <div v-if="users == null||users==undefined||Object.keys(users).length == 0" align="center">
                        <v-row>
                            <v-col cols="12" md="6" sm="12" >
                                <div class="text-h6">No users found</div>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" >
                                <v-btn class="ma-2" color="blue-darken-2" icon="mdi-plus" @click="showAddUserDialog = true"></v-btn>
                            </v-col>
                        </v-row>
                    </div>
                    <div v-else>
                        <v-container>
                            <v-row>
                                <v-col cols="12" md="12" sm="12" align="right">
                                    <v-btn class="ma-2" color="blue-darken-2" icon="mdi-plus" @click="showAddUserDialog = true"></v-btn>
                                </v-col>
                            </v-row>
                        <v-row>
                        <v-col>
                            <v-table class="border">
                                <thead>
                                    <tr>
                                        <th class="text-left"> First Name </th>
                                        <th class="text-left"> Last Name </th>
                                        <th class="text-left"> Email </th>
                                        <th class="text-left"> Phone </th>
                                        <th class="text-left"> Location </th>
                                        <th class="text-left"> Address </th>
                                        <th class="text-center" colspan="3"> Action </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in users" :key="item.id" >
                                        <td>{{ item.firstname }}</td>
                                        <td>{{ item.lastname }}</td>
                                        <td>{{ item.email }}</td>
                                        <td>{{ item.phone }}</td>
                                        <td>{{ item.location }}</td>
                                        <td>{{ item.address }}</td>
                                        <td> <v-btn color="warning" size="small"><v-icon icon="mdi-eye" ></v-icon> View</v-btn> </td>
                                        <td> <v-btn color="blue" size="small" @click="editUser(item)"><v-icon icon="mdi-pencil" ></v-icon> Edit</v-btn> </td>
                                        <td> <v-btn color="error" size="small" @click="destroyUser(item.id)"><v-icon icon="mdi-delete" ></v-icon> Delete</v-btn> </td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </v-col>
                    </v-row>
                        </v-container>
                    </div>
                </v-tabs-window-item>

                <!-- Orders -->
                <v-tabs-window-item :value="3">
                    <div v-if="orders == null||orders==undefined||Object.keys(orders).length == 0" align="center">
                        <v-row>
                            <v-col cols="12" md="6" sm="12" >
                                <div class="text-h6">No orders found</div>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" >
                                <v-btn class="ma-2" color="blue-darken-2" icon="mdi-plus" @click="showAddUserDialog = true"></v-btn>
                            </v-col>
                        </v-row>
                    </div>
                    <div v-else>
                        <v-container>
                            <v-row>
                                <v-col cols="12" md="12" sm="12" align="right">
                                    <v-btn class="ma-2" color="blue-darken-2" icon="mdi-plus" @click="showAddUserDialog = true"></v-btn>
                                </v-col>
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
                                    <tr v-for="item in orders" :key="item.id" >
                                        <td>{{ item.user.firstname + '' + item.user.lastname }}</td>
                                        <td>{{ item.product.name }}</td>
                                        <td>{{ item.product.price }}</td>
                                        <td>{{ item.quantity }}</td>
                                        <td>{{ item.quantity * item.product.price }}</td>
                                        <td>{{ item.order_status == 1 ? "Processing":"Fullfilled" }}</td>
                                        <td> <v-btn color="warning" size="small" @click="viewOrder(item)"><v-icon icon="mdi-eye"></v-icon> View</v-btn> </td>
                                        <td v-if="item.order_status == 1 "> <v-btn color="blue" size="small" @click="handleCompleteOrder(item.id)"><v-icon icon="mdi-progress-check" ></v-icon> Complete Order</v-btn> </td>
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
                        <v-col md="12">
                            <v-card v-if="previewUrl" class="mt-4 mx-auto" max-width="400">
                                <v-img :src="previewUrl" height="250" cover ></v-img>
                                <v-card-subtitle class="text-center py-2"> Image Preview </v-card-subtitle>
                            </v-card>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="Product Name" v-model="productName" required></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-select :items="categories" item-title= "name" item-value = "id" v-model ="category" label="Categories">
                            </v-select>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-file-input label="Select Image" accept="image/*" prepend-icon="mdi-camera" variant="outlined" v-model="image" @change="handleFileChange"></v-file-input>                               </v-col>
                        <v-col md="6">
                            <v-text-field label="Price" v-model="price" required></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="12">
                            <v-textarea label="Description" v-model="description" required></v-textarea>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-radio-group v-model="availability" inline>
                                <v-radio label="In Stock" value="1"></v-radio>
                                <v-radio label="Out Of Stock" value="0"></v-radio>
                            </v-radio-group>
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
                        <v-col md="12">
                            <v-card v-if="previewUrl" class="mt-4 mx-auto" max-width="400">
                                <v-img :src="previewUrl" height="250" cover ></v-img>
                                <v-card-subtitle class="text-center py-2"> Image Preview </v-card-subtitle>
                            </v-card>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="Product Name" v-model="productName" required></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-select :items="categories" item-title = "name" item-value = "id" v-model ="category">
                            </v-select>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-file-input label="Select Image" accept="image/*" prepend-icon="mdi-camera" variant="outlined" v-model="image" @change="handleFileChange"></v-file-input>                        </v-col>
                        <v-col md="6">
                            <v-text-field label="Price" v-model="price" required></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="12">
                            <v-textarea label="Description" v-model="description" required></v-textarea>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-radio-group v-model="availability" inline>
                                <v-radio label="In Stock" value="1"></v-radio>
                                <v-radio label="Out Of Stock" value="0"></v-radio>
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

    <!-- User Dialogs -->
    <!-- Add User -->
    <v-dialog v-model="showAddUserDialog" max-width="600">
        <v-form @submit.prevent >
            <v-card>
                <v-card-title class="pa-6">
                <v-row>
                        Add User
                        <v-spacer></v-spacer>
                        <v-btn class="ma-2" color="blue-darken-2" icon="mdi-close" @click="close();"></v-btn>
                    </v-row>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="First Name" v-model="firstname"></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-text-field label="Last Name" v-model="lastname"></v-text-field>
                        </v-col>
                    </v-row>
                    
                        <v-row>
                        <v-col md="6">
                            <v-text-field label="Email" v-model="email"></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-text-field label="254722345678" v-model="phone"></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-select v-model="location" label="Location" :items="['CBD', 'Madaraka', 'Westlands', 'Buruburu']" variant="outlined" ></v-select>
                        </v-col>
                        <v-col md="6">
                                <v-text-field label="Address" v-model="address"></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text="Close" variant="plain" @click="close()" ></v-btn>
                    <v-btn color="primary"  text="Save" variant="tonal" @click="addUser()" ></v-btn>
                </v-card-actions>
            </v-card>
        </v-form>
    </v-dialog>

     <!-- Edit User -->
    <v-dialog v-model="showEditUserDialog" max-width="600">
        <v-form @submit.prevent >
            <v-card>
                <v-card-title class="pa-6">
                <v-row>
                        Edit User
                        <v-spacer></v-spacer>
                        <v-btn class="ma-2" color="blue-darken-2" icon="mdi-close" @click="close();"></v-btn>
                    </v-row>
                </v-card-title>
                <v-card-text>
                    <v-row>
                        <v-col md="6">
                            <v-text-field label="First Name" v-model="firstname"></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-text-field label="Last Name" v-model="lastname"></v-text-field>
                        </v-col>
                    </v-row>
                    
                        <v-row>
                        <v-col md="6">
                            <v-text-field label="Email" v-model="email"></v-text-field>
                        </v-col>
                        <v-col md="6">
                            <v-text-field label="254722345678" v-model="phone"></v-text-field>
                        </v-col>
                    </v-row>
                    <v-row>
                        <v-col md="6">
                            <v-select v-model="location" label="Location" :items="['CBD', 'Madaraka', 'Westlands', 'Buruburu']" variant="outlined" ></v-select>
                        </v-col>
                        <v-col md="6">
                                <v-text-field label="Address" v-model="address"></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text="Close" variant="plain" @click="close()" ></v-btn>
                    <v-btn color="primary"  text="Save" variant="tonal" @click="updateUser()" ></v-btn>
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
                        {{ orders.quantity }} × ${{ orders.price }}
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