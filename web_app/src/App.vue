<script setup>
import {ref, computed} from 'vue'
import { RouterView } from 'vue-router';
import NavBar from './components/NavBar.vue';
import Chat from './components/Chat.vue';

const isChatOpen = ref(false)

</script>

<template>
  <v-app>
    <NavBar/>
    <v-main>
        <RouterView/>  
    </v-main>
    <div class="position-fixed bottom-0 end-0 ma-6 chat-container" style="z-index: 9999 !important;">
    <v-expand-transition>
      <div v-show="isChatOpen" class="mb-4">
        <Chat @close="isChatOpen = false" />
      </div>
    </v-expand-transition>

    <div class="d-flex justify-end">
      <v-btn :color="isChatOpen ? 'grey-darken-1' : 'primary'" icon elevation="4" size="large" @click="isChatOpen = !isChatOpen" >
        <v-icon :icon="isChatOpen ? 'mdi-chevron-down' : 'mdi-comment-text-multiple'"></v-icon>
      </v-btn>
    </div>
  </div>
  </v-app>

</template>

<style scoped></style>
