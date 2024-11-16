import { type HTMLAttributes } from "react";

export type Icon = HTMLAttributes<HTMLOrSVGElement>;

export const Icons = {
  ArrowBigRight: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-arrow-right"
    >
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  ),
  Earn: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-hand-coins"
    >
      <path d="M11 15h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 17" />
      <path d="m7 21 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9" />
      <path d="m2 16 6 6" />
      <circle cx="16" cy="9" r="2.9" />
      <circle cx="6" cy="5" r="3" />
    </svg>
  ),
  Home: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-house"
    >
      <path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8" />
      <path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
    </svg>
  ),
  Friends: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-handshake"
    >
      <path d="m11 17 2 2a1 1 0 1 0 3-3" />
      <path d="m14 14 2.5 2.5a1 1 0 1 0 3-3l-3.88-3.88a3 3 0 0 0-4.24 0l-.88.88a1 1 0 1 1-3-3l2.81-2.81a5.79 5.79 0 0 1 7.06-.87l.47.28a2 2 0 0 0 1.42.25L21 4" />
      <path d="m21 3 1 11h-2" />
      <path d="M3 3 2 14l6.5 6.5a1 1 0 1 0 3-3" />
      <path d="M3 4h8" />
    </svg>
  ),
  Create: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-badge-plus"
    >
      <path d="M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z" />
      <line x1="12" x2="12" y1="8" y2="16" />
      <line x1="8" x2="16" y1="12" y2="12" />
    </svg>
  ),
  Tasks: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-clipboard-list"
    >
      <rect width="8" height="4" x="8" y="2" rx="1" ry="1" />
      <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
      <path d="M12 11h4" />
      <path d="M12 16h4" />
      <path d="M8 11h.01" />
      <path d="M8 16h.01" />
    </svg>
  ),
  Wallet: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-wallet"
    >
      <path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1" />
      <path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4" />
    </svg>
  ),
  TaskWallet: (props: Icon) => (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      {...props}
      viewBox="0 0 40 40"
      fill="none"
    >
      <rect height="40" width="40" rx="10" fill="#4C9CE2" />
      <path
        d="M28.1007 24.4696C26.2461 24.4696 23.7454 24.8717 22.1417 23.7645C20.7507 22.8042 20.5786 21.332 20.5786 19.7828C20.5786 17.9139 20.6571 16.2388 22.4347 15.1417C23.215 14.6602 23.995 14.7054 24.877 14.7054H28.1007C27.93 13.1329 26.1959 12.2274 24.7793 12.0858C22.5131 11.8593 20.1215 12.0691 17.8433 12.0691C16.4411 12.0691 14.8097 11.8562 13.4473 12.2438C12.2399 12.5871 11.1573 13.7589 10.9395 14.9983C10.7483 16.0861 10.8097 17.2183 10.8097 18.3182V21.5403C10.8097 23.4059 10.8457 25.2394 12.5681 26.387C13.7003 27.1415 15.1777 27.0083 16.4757 27.0083H22.044C23.2886 27.0083 24.5386 27.0926 25.7562 26.7896C26.8414 26.5195 27.8273 25.5513 28.1007 24.4696ZM23.607 16.0264C21.5649 16.4975 21.69 19.0311 21.9048 20.6616C21.9906 21.3132 22.0174 21.8713 22.4864 22.3897C23.5047 23.5155 25.5638 23.1026 26.9284 23.1026C27.4665 23.1026 28.0617 23.1719 28.5892 23.051C30.4967 22.6132 30.3476 20.6341 30.3476 19.0993C30.3476 18.2938 30.3807 17.4125 29.8259 16.7598C28.8233 15.5803 26.7445 15.9748 25.3654 15.9748C24.7973 15.9748 24.1635 15.8981 23.607 16.0264Z"
        fill="#FEFFFF"
      />
    </svg>
  ),
  TaskPool: (props: Icon) => (
    <svg
      {...props}
      width="80"
      height="37"
      viewBox="0 0 80 37"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <g clip-path="url(#clip0_27_47)">
        <path
          d="M12.7488 28.309C11.2383 28.309 9.91981 27.9901 8.79365 27.3525C7.6671 26.6895 6.78393 25.7968 6.14393 24.6748V36.0748H0V7.84243H5.33757V11.094C6.08 9.94636 7.01421 9.05383 8.14075 8.41608C9.2671 7.77869 10.5856 7.45981 12.0959 7.45981C13.4527 7.45981 14.6942 7.72766 15.8207 8.26318C16.9727 8.79869 17.971 9.53832 18.8159 10.4819C19.6606 11.4256 20.3135 12.5222 20.7742 13.772C21.235 15.0215 21.4654 16.3733 21.4654 17.8269C21.4654 19.8163 21.0942 21.6015 20.3518 23.1828C19.6093 24.7639 18.5727 26.0136 17.2415 26.9318C15.9359 27.8499 14.4385 28.309 12.7488 28.309ZM10.6751 23.1445C11.3406 23.1445 11.9424 23.0041 12.4798 22.7237C13.0361 22.4232 13.5311 22.0209 13.9391 21.5378C14.3486 21.0531 14.6559 20.4921 14.8606 19.8546C15.0912 19.1903 15.2081 18.4919 15.2064 17.7888C15.2064 17.0492 15.0783 16.3733 14.8222 15.7611C14.5918 15.1492 14.2591 14.6135 13.8239 14.1544C13.3886 13.6699 12.8766 13.3002 12.2879 13.045C11.6991 12.7901 11.0591 12.6624 10.3679 12.6624C9.95832 12.6624 9.53607 12.7262 9.10056 12.8538C8.69121 12.9813 8.29439 13.1725 7.91028 13.4277C7.55196 13.6572 7.21907 13.9378 6.91196 14.2692C6.60467 14.6007 6.34878 14.9832 6.14393 15.4168V19.5484C6.42561 20.237 6.79682 20.8492 7.25757 21.3847C7.71832 21.9204 8.24318 22.3538 8.83196 22.6854C9.42075 22.9914 10.0353 23.1445 10.6751 23.1445ZM33.3942 28.309C31.6791 28.309 30.143 28.0284 28.7862 27.4673C27.4551 26.9062 26.3286 26.1411 25.4071 25.172C24.4913 24.2121 23.7737 23.0811 23.2951 21.8437C22.8342 20.5942 22.6039 19.2807 22.6039 17.9036C22.6039 16.5007 22.8342 15.1746 23.2951 13.9249C23.7737 12.6875 24.4913 11.5565 25.4071 10.5966C26.3286 9.62766 27.4551 8.86243 28.7862 8.30131C30.143 7.74037 31.6791 7.45981 33.3942 7.45981C35.1093 7.45981 36.6325 7.74019 37.9637 8.3015C39.295 8.86243 40.4213 9.62766 41.343 10.5968C42.2587 11.5567 42.9763 12.6876 43.455 13.9249C43.9413 15.1746 44.1845 16.5007 44.1845 17.9036C44.1845 19.2807 43.9413 20.5942 43.455 21.8437C42.9764 23.0811 42.2587 24.212 41.343 25.172C40.4213 26.1411 39.295 26.9062 37.9637 27.4673C36.6325 28.0284 35.1093 28.309 33.3942 28.309ZM28.9015 17.9034C28.9015 18.9492 29.0935 19.8673 29.4774 20.6579C29.8871 21.4484 30.4247 22.0606 31.0903 22.4942C31.7559 22.9277 32.5237 23.1445 33.3942 23.1445C34.2391 23.1445 34.9942 22.9277 35.6598 22.4942C36.351 22.0351 36.8886 21.4103 37.2725 20.6196C37.6566 19.829 37.8486 18.9236 37.8486 17.9036C37.8486 16.8578 37.6566 15.9396 37.2725 15.1492C36.8886 14.3585 36.351 13.7464 35.6598 13.3129C34.9942 12.8793 34.2391 12.6624 33.3942 12.6624C32.5237 12.6624 31.7559 12.8793 31.0903 13.3129C30.4247 13.7465 29.8871 14.3585 29.4774 15.1492C29.0935 15.9398 28.9015 16.8576 28.9015 17.9034ZM56.0636 28.309C54.3484 28.309 52.8123 28.0284 51.4555 27.4673C50.1243 26.9062 48.9979 26.1411 48.0765 25.172C47.1607 24.2121 46.443 23.0811 45.9645 21.8437C45.5036 20.5942 45.2733 19.2807 45.2733 17.9036C45.2733 16.5007 45.5036 15.1746 45.9645 13.9249C46.443 12.6875 47.1607 11.5565 48.0765 10.5966C48.9979 9.62766 50.1243 8.86243 51.4555 8.30131C52.8123 7.74037 54.3484 7.45981 56.0636 7.45981C57.7787 7.45981 59.3019 7.74019 60.6331 8.3015C61.9643 8.86243 63.0907 9.62766 64.0121 10.5968C64.9338 11.5658 65.6378 12.6753 66.1243 13.9249C66.6107 15.1746 66.8538 16.5007 66.8538 17.9036C66.8538 19.2807 66.6107 20.5942 66.1243 21.8437C65.6457 23.0811 64.9279 24.212 64.0121 25.172C63.0907 26.1411 61.9643 26.9062 60.6331 27.4673C59.3019 28.0284 57.7787 28.309 56.0636 28.309ZM51.5707 17.9034C51.5707 18.9492 51.7628 19.8673 52.1467 20.6579C52.5563 21.4484 53.094 22.0606 53.7594 22.4942C54.425 22.9277 55.1931 23.1445 56.0636 23.1445C56.9082 23.1445 57.6636 22.9277 58.3292 22.4942C59.0202 22.0351 59.5579 21.4103 59.9419 20.6196C60.3258 19.829 60.5179 18.9236 60.5179 17.9036C60.5179 16.8578 60.3258 15.9396 59.9419 15.1492C59.5579 14.3585 59.0202 13.7464 58.3292 13.3129C57.6636 12.8793 56.9082 12.6624 56.0636 12.6624C55.1931 12.6624 54.425 12.8793 53.7594 13.3129C53.094 13.7465 52.5563 14.3585 52.1467 15.1492C51.7628 15.9398 51.5707 16.8576 51.5707 17.9034ZM69.0561 0H75.2V20.7727C75.2 21.6142 75.3536 22.2136 75.6607 22.5707C75.968 22.9277 76.4032 23.1062 76.9664 23.1062C77.3505 23.1062 77.7344 23.0551 78.1185 22.9533C78.528 22.8256 78.8864 22.6854 79.1936 22.5323L80 27.123C79.232 27.48 78.3488 27.7606 77.3505 27.9647C76.352 28.1686 75.4176 28.2707 74.5473 28.2707C72.8065 28.2707 71.4497 27.8116 70.4768 26.8935C69.5297 25.9499 69.0561 24.6237 69.0561 22.915V0Z"
          fill="#2989EC"
        />
      </g>
      <defs>
        <clipPath id="clip0_27_47">
          <rect width="80" height="36.0748" fill="white" />
        </clipPath>
      </defs>
    </svg>
  ),
  TaskTwitter: (props: Icon) => (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      {...props}
      viewBox="0 0 40 40"
      fill="none"
    >
      <rect height="40" width="40" rx="10" fill="#2B2B2B" />
      <path
        d="M18.488 22.651L23.25 29H30.25L22.392 18.522L28.93 11H26.28L21.163 16.886L16.75 11H9.75L17.26 21.015L10.32 29H12.97L18.488 22.651ZM24.25 27L13.75 13H15.75L26.25 27H24.25Z"
        fill="white"
      />
    </svg>
  ),
  TaskTelegram: (props: Icon) => (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      {...props}
      viewBox="0 0 40 40"
      fill="none"
    >
      <rect height="40" width="40" rx="10" fill="#7C7C7C" />
      <rect height="40" width="40" rx="10" fill="#3096EF" />
      <path
        d="M27.7101 12.6545C27.7101 12.6545 29.6526 11.897 29.4901 13.7365C29.4366 14.494 28.9511 17.1455 28.5731 20.013L27.2781 28.508C27.2781 28.508 27.1701 29.7525 26.1986 29.969C25.2276 30.185 23.7706 29.2115 23.5006 28.995C23.2846 28.8325 19.4536 26.3975 18.1046 25.2075C17.7266 24.8825 17.2946 24.2335 18.1586 23.476L23.8246 18.065C24.4721 17.415 25.1196 15.9 22.4216 17.74L14.8666 22.88C14.8666 22.88 14.0031 23.4215 12.3846 22.9345L8.87665 21.852C8.87665 21.852 7.58165 21.0405 9.79415 20.229C15.1906 17.686 21.8281 15.089 27.7096 12.654"
        fill="white"
      />
    </svg>
  ),
  TaskInvite: (props: Icon) => (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      {...props}
      viewBox="0 0 40 40"
      fill="none"
    >
      <rect height="40" width="40" rx="10" fill="#34C759" />
      <path
        d="M27.5833 25.8571V28H14.5833V25.8571C14.5833 25.8571 14.5833 21.5714 21.0833 21.5714C27.5833 21.5714 27.5833 25.8571 27.5833 25.8571ZM24.3333 16.2143C24.3333 15.5786 24.1427 14.9571 23.7856 14.4285C23.4285 13.8999 22.9209 13.488 22.3271 13.2447C21.7332 13.0014 21.0797 12.9377 20.4493 13.0618C19.8189 13.1858 19.2398 13.4919 18.7852 13.9414C18.3307 14.391 18.0212 14.9637 17.8958 15.5872C17.7704 16.2107 17.8347 16.857 18.0807 17.4443C18.3267 18.0317 18.7433 18.5337 19.2777 18.8869C19.8122 19.2401 20.4405 19.4286 21.0833 19.4286C21.9453 19.4286 22.7719 19.0899 23.3814 18.4871C23.9909 17.8843 24.3333 17.0668 24.3333 16.2143ZM27.8 21.6357C28.3922 22.176 28.8696 22.8276 29.2044 23.5524C29.5392 24.2772 29.7247 25.0607 29.75 25.8571V28H33V25.8571C33 25.8571 33 22.1607 27.8 21.6357ZM26.5 13C26.1727 13 25.8474 13.0506 25.5358 13.15C26.1696 14.0489 26.5095 15.1184 26.5095 16.2143C26.5095 17.3102 26.1696 18.3797 25.5358 19.2786C25.8474 19.3779 26.1727 19.4286 26.5 19.4286C27.362 19.4286 28.1886 19.0899 28.7981 18.4871C29.4076 17.8843 29.75 17.0668 29.75 16.2143C29.75 15.3618 29.4076 14.5442 28.7981 13.9414C28.1886 13.3386 27.362 13 26.5 13ZM15.6667 18.3571H12.4167V15.1429H10.25V18.3571H7V20.5H10.25V23.7143H12.4167V20.5H15.6667V18.3571Z"
        fill="white"
      />
    </svg>
  ),
  ChevronLeft: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-arrow-right"
    >
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  ),
  Plus: (props: Icon) => (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="lucide lucide-plus"
    >
      <path d="M5 12h14" />
      <path d="M12 5v14" />
    </svg>
  ),
};