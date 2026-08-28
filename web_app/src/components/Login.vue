<script setup>
import { ref } from 'vue'
import { useAuth } from '@/services/auth'
import { useRouter } from 'vue-router'

const router = useRouter();

const { checkCredentials } = useAuth()

const rules = {
    required: value => !!value || 'Required.',
    min: v => v.length >= 8 || 'Min 8 characters',
    passwordMatch: () => password == confirmPassword || 'Passwords must match'
  }

  //data models

const email = ref(null)
const password = ref(null) 
const showPassword = ref(false)

function login()
{
    const data = {
        email: email.value,
        password: password.value,
    }
    checkCredentials(data)
    router.push('/')
}

</script>

<template>
    <v-container align="center" class="mt-12">
        <v-row>
            <v-col>
                <v-card max-width="80%" class="bg-primary"> 
                    <v-img src="/FullLogo_Transparent.png" height="150" width="200" class="mt-2"></v-img>
                    <v-card-title class="ma-5">Login</v-card-title>
                    <v-divider></v-divider>
                    <v-form class="mt-12 mb-6 mr-8">
                        <v-row>
                            <v-col md="4">
                                <div>Email</div>
                            </v-col>
                            <v-col md="4">
                                <v-text-field placeholder="123example@gmail.com" v-model="email"></v-text-field>
                            </v-col>
                        </v-row>
                         <v-row>
                            <v-col md="4">
                                <div>Password</div>
                            </v-col>
                            <v-col md="4">
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
                        </v-row>

                        <v-row>
                            <v-col md="4">
                                <v-btn width="300" @click="login()" >Login</v-btn>
                            </v-col>
                            <v-col md="4">
                                <div>
                                    Forgot password
                                    <router-link to="/signup" class="text-blue-darken-2">Forgot password</router-link>
                                </div>
                            </v-col>
                            <v-col md="4">
                                <div>
                                    Don't have an account?
                                   <router-link to="/signup" class="text-blue-darken-2">Create</router-link>
                                </div>
                            </v-col>
                        </v-row>
                    </v-form>
                </v-card>
            </v-col>
        </v-row>
    </v-container>


</template>