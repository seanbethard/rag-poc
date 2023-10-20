<script setup>
import { Authenticator } from '@aws-amplify/ui-vue';
import '@aws-amplify/ui-vue/styles.css';
</script>
<template>
  <authenticator>
    <template v-slot="{ user, signOut }">
      <div class="q-pa-md row justify-center">
        <div style="width: 100%; max-width: 400px">
          <q-chat-message
            :text="['what are the rocker box torque specs for a 1999 evo']"
            sent
            text-color="white"
            bg-color="primary"
          >
            <template v-slot:name>{{ user.username }}</template>
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

            <div>
              For a 1999 Harley-Davidson Evolution engine (or Evo), you would
              generally torque the rocker box bolts to these specifications:<br />
              <br />
              1. Lower rocker box bolts: 10 - 13 ft-lbs<br />
              2. Middle rocker box bolts: 10 - 13 ft-lbs<br />
              3. Upper rocker box bolts: 15 - 18 ft-lbs<br />
              <br />
              Please also remember to follow proper torque sequence.
            </div>
          </q-chat-message>
          <q-chat-message
            :text="['what is the proper torque sequence']"
            sent
            text-color="white"
            bg-color="primary"
          >
            <template v-slot:name>{{ user.username }}</template>
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

            <div>
              Usually, the manufacturer's service manual will provide the exact
              sequence for each specific model. However, a common approach for
              Harley-Davidson's rocker boxes might be as followed:<br />
              <br />
              For the lower rocker box:
              <br />
              1. Start with bolt 1 (center bolt), then move to bolt 2 (diagonal
              to bolt 1).<br />
              2. Then tighten bolt 3, which is diagonal to bolt 2, and then bolt
              4 (diagonal to bolt 3).<br />
              3. Repeat this pattern until all bolts are tightened.<br />
              <br />
              For the middle rocker box:<br />
              <br />
              1. Start with bolt 1 located in the center.<br />
              2. After that, the sequence is similar: proceed with bolts 2, 3,
              and so on in a criss-cross pattern.<br />
              <br />
              For the upper rocker box:<br />
              <br />
              1. Start with one of the two center bolts, then proceed with the
              opposite one.<br />
              2. After both center bolts have been tightened, move on to the
              other bolts in a criss-cross pattern.<br />
              <br />
              Generally, the goal is to apply uniform pressure throughout the
              assembly. It's always recommended to tighten everything in
              multiple stages, gradually, to avoid over-tightening and damaging
              the parts.
            </div>
          </q-chat-message>
        </div>
      </div>
      <div class="q-pa-md q-gutter-sm row justify-center">
        <q-btn
          :ripple="{ color: 'yellow' }"
          push
          color="primary"
          label="Sign Out"
          @click="signOut"
        />
      </div>
    </template>
  </authenticator>
</template>
