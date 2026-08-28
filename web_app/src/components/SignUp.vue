<script setup>
import { ref } from 'vue'
import { useAuth } from '@/services/auth'
import { useRouter } from 'vue-router'
const router = useRouter();

const { signup } = useAuth()

const showPassword = ref(false)
const password = ref(null) 

const confirmPassword= ref(null)
const showConfirm = ref(false)
const rules = {
    required: value => !!value || 'Required.',
    min: v => v.length >= 8 || 'Min 8 characters',
    passwordMatch: () => password == confirmPassword || 'Passwords must match'
  }

  //data models

const firstname = ref(null)
const lastname = ref(null)
const email = ref(null)
const address = ref(null)
const phonenumber = ref(null)
const location = ref(null)

function register()
{
    const data = {
        firstname: firstname.value,
        lastname: lastname.value,
        email: email.value,
        address: address.value,
        phonenumber: phonenumber.value,
        location: location.value,
        password: password.value,
        role: 2,                      
        
        //role 1 is for admin, role 2 is for customer
    }
    signup(data)
    router.push('/').then(() =>{
        router.go(0)
    });
}

</script>

<template>
    <v-container align="center" class="mt-12">
        <v-row>
            <v-col>
                <v-card max-width="80%" class="bg-primary"> 
                    <v-img src="/public/FullLogo_Transparent.png" height="150" width="200" class="mt-2"></v-img>
                    <v-card-title class="ma-5">Sign Up</v-card-title>
                    <v-divider></v-divider>
                    <v-form class="mt-12 mb-6 mr-8">
                        <v-row>
                            <v-col md="3">
                                <div lable>First Name</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field placeholder="First Name" v-model="firstname"></v-text-field>
                            </v-col>
                            <v-col md="3">
                                <div>Last Mane</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field placeholder="Last Name" v-model="lastname"></v-text-field>
                            </v-col>
                        </v-row>

                         <v-row>
                            <v-col md="3">
                                <div>Email</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field placeholder="123example@gmail.com" v-model="email"></v-text-field>
                            </v-col>
                            <v-col md="3">
                                <div>Phone Number</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field type="tel" placeholder="+254712345678" v-model="phonenumber"></v-text-field>
                            </v-col>
                        </v-row>

                         <v-row>
                            <v-col md="3">
                                <div>Location</div>
                            </v-col>
                            <v-col md="3">
                                <v-select :items="['Nairobi', 'Lamu', 'Narok', 'Naivasha', 'Samburu']" v-model="location"></v-select>
                            </v-col>
                            <v-col md="3">
                                <div>Address</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field placeholder="address" v-model="address"></v-text-field>
                            </v-col>
                        </v-row>

                         <v-row>
                            <v-col md="3">
                                <div>Password</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field 
                                placeholder="password"
                                v-model="password"
                                :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                                :rules="[rules.required, rules.min]"
                                :type="showPassword ? 'text' : 'password'"
                                variant="outlined"
                                @click:append="showPassword = !showPassword"
                            > </v-text-field>
                            </v-col>
                            <v-col md="3">
                                <div>Confirm Password</div>
                            </v-col>
                            <v-col md="3">
                                <v-text-field 
                                placeholder="confirm password"
                                v-model="confirmPassword"
                                :append-icon="showConfirm ? 'mdi-eye' : 'mdi-eye-off'"
                                :rules="[rules.required, rules.min, rules.passwordMatch,]"
                                :type="showConfirm ? 'text' : 'password'"
                                variant="outlined"
                                @click:append="showConfirm = !showConfirm"
                            ></v-text-field>
                            </v-col>
                        </v-row>

                        <v-row>
                            <v-col md="6">
                                <v-btn width="300" @click="register()" >Sign Up</v-btn>
                            </v-col>
                            <v-col md="6">
                                <div>
                                    Already have an account?
                                    <router-link to="/login" class="text-blue-darken-2">Login</router-link>
                                </div>
                            </v-col>
                        </v-row>
                    </v-form>
                </v-card>
            </v-col>
        </v-row>
    </v-container>


</template>