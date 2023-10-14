<template>
  <div class="q-pa-md row justify-center">
    <div style="width: 100%; max-width: 400px">
      <q-chat-message
        :text="['I need a carburetor rebuild kit for a 1989 softail']"
        sent
        text-color="white"
        bg-color="primary"
      >
        <template v-slot:name>me</template>
        <template v-slot:stamp>2 minutes ago</template>
        <template v-slot:avatar>
          <img
            class="q-message-avatar q-message-avatar--sent"
            src="https://static.wikia.nocookie.net/non-aliencreatures/images/5/51/Gnorm1.jpg"
          />
        </template>
      </q-chat-message>

      <q-chat-message bg-color="amber">
        <template v-slot:name>Scumbag</template>
        <template v-slot:avatar>
          <img
            class="q-message-avatar q-message-avatar--received"
            src="https://static.wikia.nocookie.net/wasteland_gamepedia/images/2/24/WL_ani_114.gif"
          />
        </template>

        <q-spinner-dots size="2rem" />
      </q-chat-message>
    </div>
  </div>
</template>

<style lang="sass">
.my-emoji
  vertical-align: middle
  height: 2em
  width: 2em
</style>
