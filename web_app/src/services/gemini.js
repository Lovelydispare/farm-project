import { ref } from 'vue'
import { GoogleGenAI } from '@google/genai'
import { useProductsStore } from '../stores/products'

// Initialize client. Secure your VITE_GEMINI_API_KEY in your deployment platform console.
const ai = new GoogleGenAI({ apiKey: import.meta.env.VITE_GEMINI_API_KEY })


export function useFarmShopAI() {
  const messages = ref([
    { 
      role: 'model', 
      parts: [{ text: "Hello! I'm your ShambaOnline assistant. Ask me anything about our produce, nutrition, or meal prep ideas!" }] 
    }
  ])
  const isLoading = ref(false)

const products= useProductsStore().products
const catalog = Object.values(products).map(b => `"${b.name}" as a ${b.category}`).join(', ')

  // Guardrails to lock the model into a farm produce domain
  const systemInstruction = `You are an AI assistant for a local farm-produce online grocery shop. 
    Your job is to help customers with:
    1. Identifying and choosing farm-fresh produce.
    2. Nutritional facts, health benefits, and dietary information.
    3. Meal preparation, washing/storing tips, and recipe ideas using fresh vegetables and fruits.
    
    Guidelines:
    - Keep answers concise, warm, and helpful.
    - If a user asks about non-food, non-grocery, or political topics, politely decline and steer them back to farm produce.
    - Format recipes with clean bullet points.`

  async function sendMessage(userText) {
    if (!userText.trim()) return
    
    messages.value.push({ role: 'user', parts: [{ text: userText }] })
    isLoading.value = true

    try {
      const chatSession = ai.chats.create({
        model: 'gemini-2.5-flash',
        config: { systemInstruction }
      })

      const response = await chatSession.sendMessage({ message: userText })
      
      messages.value.push({
        role: 'model',
        parts: [{ text: response.text }]
      })
    } catch (error) {
      console.error("FarmChat AI Error:", error)
      messages.value.push({
        role: 'model',
        parts: [{ text: "Oops! My pages got stuck. Please try sending your message again." }]
      })
    } finally {
      isLoading.value = false
    }
  }

  return { messages, isLoading, sendMessage }
}