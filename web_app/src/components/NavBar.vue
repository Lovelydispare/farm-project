<script setup>
import {useAuth}  from '../services/auth'
import { useRouter } from "vue-router";

const router = useRouter();
const { logout } = useAuth()
const isAuthenticated = localStorage.getItem('isAuthenticated')
const isAdmin = localStorage.getItem('isAdmin')

const user = JSON.parse(localStorage.getItem('user'))

let role = 0
let letter = ''
if(user){
    letter = user.firstname[0]
    role = user.role_id
}

function logOut(){
    logout()
    router.push('/').then(() => {
        router.go(0)
    });
}

</script>

<template>
    <v-app-bar color="primary">
        <v-app-bar-title> 
            <router-link to="/">
                <v-img src="logo.png" width="12%" height="12%"></v-img>
            </router-link>
        </v-app-bar-title>
        <v-btn to="/">Home</v-btn>
        <v-btn to="/seller_view" v-if="role == 3">Seller</v-btn>
        <v-btn to="/product">Products</v-btn>
        <v-btn to="/admin" v-if="role == 1">Admin</v-btn>
        <v-btn icon="mdi-account" v-if="isAuthenticated" variant="tonal">{{letter}}
            <v-menu activator="parent">
                <v-list>
                    <v-list-item>
                        <v-btn color="primary" to="/profile">Profile</v-btn>                        
                    </v-list-item>
                    <v-list-item>
                        <v-btn color="primary" @click="()=> { logOut(); }">Logout</v-btn>                        
                    </v-list-item>
                </v-list>
            </v-menu>
        </v-btn>
        <v-btn to="/login" v-else>Login</v-btn>
    </v-app-bar>
</template>
