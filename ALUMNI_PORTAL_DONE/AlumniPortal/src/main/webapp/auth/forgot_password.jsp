<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Forgot Password | MEASI Alumni Portal</title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --brand-maroon: #7a0f1b; --brand-green: #0b4b3b; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            background:
                linear-gradient(rgba(122,15,27,0.80), rgba(11,75,59,0.75)),
                url('<%=request.getContextPath()%>/assets/img/hero.png') center center/cover no-repeat;
            display: flex; align-items: center; justify-content: center; padding: 30px 15px;
        }
        .wrapper {
            width: 100%; max-width: 1000px;
            display: grid; grid-template-columns: 1fr 420px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 24px; overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.28);
            backdrop-filter: blur(6px);
        }
        /* LEFT */
        .left-panel {
            padding: 60px 48px; color: #fff;
            display: flex; flex-direction: column; justify-content: center;
            background: linear-gradient(135deg, rgba(0,0,0,0.28), rgba(0,0,0,0.08));
        }
        .left-badge {
            display: inline-block; align-self: flex-start;
            padding: 7px 18px; border-radius: 999px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.18);
            font-size: 12px; font-weight: 700; letter-spacing: .6px;
            margin-bottom: 24px;
        }
        .left-panel h1 {
            font-family: 'Playfair Display', serif;
            font-size: 46px; line-height: 1.1; margin: 0 0 16px; font-weight: 800;
        }
        .left-panel p { font-size: 17px; line-height: 1.7; color: #f3f4f6; max-width: 420px; margin: 0; }
        .steps-list { margin-top: 36px; display: flex; flex-direction: column; gap: 16px; }
        .step-item { display: flex; align-items: flex-start; gap: 14px; }
        .step-num {
            width: 30px; height: 30px; border-radius: 50%;
            background: rgba(255,213,79,0.2); border: 1.5px solid rgba(255,213,79,0.5);
            color: #ffd54f; font-size: 13px; font-weight: 800;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .step-text { font-size: 14px; color: rgba(255,255,255,0.85); padding-top: 5px; }
        /* RIGHT CARD */
        .right-card {
            background: #fff; padding: 44px 36px;
            display: flex; flex-direction: column; justify-content: center;
        }
        .brand-row {
            display: flex; align-items: center; gap: 12px; margin-bottom: 24px;
        }
        .brand-logo {
            width: 48px; height: 48px; border-radius: 10px;
            background: rgba(255,255,255,0.9); padding: 4px;
            object-fit: contain; border: 1px solid #f0ece6;
        }
        .brand-text { font-size: 14px; font-weight: 800; color: var(--brand-maroon); line-height: 1.2; }
        .card-title {
            font-family: 'Playfair Display', serif;
            font-size: 28px; font-weight: 800; color: var(--brand-maroon); margin-bottom: 6px;
        }
        .card-sub { font-size: 14px; color: #888; margin-bottom: 28px; }

        /* STEPS */
        .step-section { display: none; }
        .step-section.active { display: block; }

        /* Fields */
        .field-label {
            font-size: 12px; font-weight: 700; color: #444;
            text-transform: uppercase; letter-spacing: .5px; display: block; margin-bottom: 5px;
        }
        .field-wrap { position: relative; margin-bottom: 16px; }
        .field-icon { position: absolute; left: 13px; top: 50%; transform: translateY(-50%); color: #bbb; font-size: 15px; }
        .field-input {
            width: 100%; height: 48px; padding: 0 14px 0 38px;
            border: 1.5px solid #e0dbd4; border-radius: 11px;
            font-size: 14px; font-family: 'DM Sans', sans-serif;
            background: #faf9f7; outline: none; transition: border-color .2s, box-shadow .2s;
        }
        .field-input:focus { border-color: var(--brand-maroon); box-shadow: 0 0 0 3px rgba(122,15,27,.07); }
        .eye-toggle { position: absolute; right: 13px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #bbb; font-size: 15px; }
        .eye-toggle:hover { color: var(--brand-maroon); }

        /* OTP boxes */
        .otp-row { display: flex; gap: 8px; justify-content: center; margin-bottom: 16px; }
        .otp-box {
            width: 48px; height: 54px;
            border: 1.5px solid #e0dbd4; border-radius: 10px;
            font-size: 22px; font-weight: 700; text-align: center;
            background: #faf9f7; outline: none; font-family: 'DM Sans', sans-serif;
            transition: border-color .2s, box-shadow .2s;
        }
        .otp-box:focus { border-color: var(--brand-maroon); box-shadow: 0 0 0 3px rgba(122,15,27,.07); }

        /* Buttons */
        .btn-main {
            width: 100%; height: 48px;
            background: var(--brand-maroon); color: #fff; border: none;
            border-radius: 11px; font-size: 14px; font-weight: 700;
            font-family: 'DM Sans', sans-serif; cursor: pointer;
            transition: background .2s; display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-main:hover { background: #5a0a13; }
        .btn-main:disabled { opacity: .6; cursor: not-allowed; }
        .btn-outline {
            width: 100%; height: 42px;
            background: none; color: var(--brand-maroon);
            border: 1.5px solid var(--brand-maroon);
            border-radius: 11px; font-size: 13px; font-weight: 700;
            font-family: 'DM Sans', sans-serif; cursor: pointer;
            transition: all .2s; margin-top: 10px;
        }
        .btn-outline:hover { background: #fdf0f1; }

        /* Alerts */
        .alert-err { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; border-radius: 10px; padding: 11px 14px; font-size: 13px; margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }
        .alert-ok  { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; border-radius: 10px; padding: 11px 14px; font-size: 13px; margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }
        .alert-info{ background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; border-radius: 10px; padding: 11px 14px; font-size: 13px; margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }

        /* Progress dots */
        .progress-dots {
            display: flex; gap: 6px; justify-content: center; margin-bottom: 24px;
        }
        .dot { width: 8px; height: 8px; border-radius: 50%; background: #e0dbd4; transition: all .3s; }
        .dot.active { background: var(--brand-maroon); width: 22px; border-radius: 4px; }
        .dot.done   { background: var(--brand-green); }

        /* Timer */
        .otp-timer { font-size: 12px; color: #999; text-align: center; margin-bottom: 12px; }
        .otp-timer span { font-weight: 700; color: var(--brand-maroon); }

        .back-to-login {
            display: block; text-align: center; margin-top: 20px;
            font-size: 13px; color: #aaa; text-decoration: none;
        }
        .back-to-login:hover { color: var(--brand-maroon); }

        /* Strength bar */
        .strength-bar { display: flex; gap: 4px; margin-top: 6px; margin-bottom: 4px; }
        .strength-seg { flex: 1; height: 4px; border-radius: 2px; background: #e0dbd4; transition: background .3s; }
        .strength-label { font-size: 11px; color: #aaa; margin-bottom: 8px; }

        @media(max-width:840px){
            .wrapper { grid-template-columns: 1fr; }
            .left-panel { padding: 32px 24px 20px; }
            .left-panel h1 { font-size: 32px; }
            .steps-list { display: none; }
            .right-card { padding: 28px 20px; }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <!-- LEFT -->
    <div class="left-panel">
        <div class="left-badge">MEASI ALUMNI PORTAL</div>
        <h1>Forgot Your<br>Password?</h1>
        <p>No worries! Reset it in 3 simple steps using your registered email address.</p>
        <div class="steps-list">
            <div class="step-item">
                <div class="step-num">1</div>
                <div class="step-text">Enter your registered <strong>email address</strong></div>
            </div>
            <div class="step-item">
                <div class="step-num">2</div>
                <div class="step-text">Enter the <strong>OTP</strong> sent to your email</div>
            </div>
            <div class="step-item">
                <div class="step-num">3</div>
                <div class="step-text">Set your <strong>new password</strong></div>
            </div>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="right-card">
        <div class="brand-row">
            <img src="<%=request.getContextPath()%>/assets/img/logoonly.PNG"
                 alt="MEASI Logo" class="brand-logo">
            <div class="brand-text">MEASI Alumni Portal<br><span style="font-weight:400;color:#888;">Password Recovery</span></div>
        </div>
        <div class="card-title">Reset Password</div>
        <div class="card-sub" id="stepSubtitle">Enter your registered email to receive a reset OTP.</div>

        <!-- PROGRESS DOTS -->
        <div class="progress-dots">
            <div class="dot active" id="dot1"></div>
            <div class="dot"       id="dot2"></div>
            <div class="dot"       id="dot3"></div>
        </div>

        <!-- ALERT -->
        <div id="alertBox" style="display:none;"></div>

        <!-- STEP 1: Email -->
        <div class="step-section active" id="step1">
            <label class="field-label" for="emailInput">Email Address</label>
            <div class="field-wrap">
                <i class="bi bi-envelope field-icon"></i>
                <input type="email" id="emailInput" class="field-input"
                       placeholder="your@email.com" autocomplete="email">
            </div>
            <button class="btn-main" onclick="submitEmail()">
                <i class="bi bi-send"></i> Send OTP
            </button>
            <a class="back-to-login" href="<%=request.getContextPath()%>/auth/login.jsp">
                <i class="bi bi-arrow-left me-1"></i> Back to Login
            </a>
        </div>

        <!-- STEP 2: OTP -->
        <div class="step-section" id="step2">
            <p style="font-size:13px;color:#666;margin-bottom:14px;text-align:center;">
                We sent a 6-digit OTP to <strong id="emailDisplay"></strong>
            </p>
            <div class="otp-row">
                <input type="text" class="otp-box" id="otp1" maxlength="1" oninput="moveFocus(this,'','otp2')">
                <input type="text" class="otp-box" id="otp2" maxlength="1" oninput="moveFocus(this,'otp1','otp3')">
                <input type="text" class="otp-box" id="otp3" maxlength="1" oninput="moveFocus(this,'otp2','otp4')">
                <input type="text" class="otp-box" id="otp4" maxlength="1" oninput="moveFocus(this,'otp3','otp5')">
                <input type="text" class="otp-box" id="otp5" maxlength="1" oninput="moveFocus(this,'otp4','otp6')">
                <input type="text" class="otp-box" id="otp6" maxlength="1" oninput="moveFocus(this,'otp5','')">
            </div>
            <div class="otp-timer" id="timerDisplay">Resend OTP in <span id="timerCount">60</span>s</div>
            <button class="btn-main" onclick="verifyOtp()">
                <i class="bi bi-shield-check"></i> Verify OTP
            </button>
            <button class="btn-outline" id="resendBtn" disabled onclick="resendOtp()">
                <i class="bi bi-arrow-repeat me-1"></i> Resend OTP
            </button>
            <a class="back-to-login" onclick="goStep(1)" href="javascript:void(0);">
                <i class="bi bi-arrow-left me-1"></i> Change Email
            </a>
        </div>

        <!-- STEP 3: New Password -->
        <div class="step-section" id="step3">
            <label class="field-label">New Password</label>
            <div class="field-wrap">
                <i class="bi bi-lock field-icon"></i>
                <input type="password" id="newPwd" class="field-input"
                       placeholder="Min 8 characters" oninput="checkStrength(this.value)">
                <i class="bi bi-eye-slash eye-toggle" id="eye1" onclick="toggleEye('newPwd','eye1')"></i>
            </div>
            <div class="strength-bar">
                <div class="strength-seg" id="seg1"></div>
                <div class="strength-seg" id="seg2"></div>
                <div class="strength-seg" id="seg3"></div>
                <div class="strength-seg" id="seg4"></div>
            </div>
            <div class="strength-label" id="strengthLabel"></div>

            <label class="field-label">Confirm New Password</label>
            <div class="field-wrap">
                <i class="bi bi-lock field-icon"></i>
                <input type="password" id="confirmPwd" class="field-input"
                       placeholder="Repeat password">
                <i class="bi bi-eye-slash eye-toggle" id="eye2" onclick="toggleEye('confirmPwd','eye2')"></i>
            </div>
            <small id="pwdMatchErr" class="text-danger d-none fw-semibold">Passwords do not match</small>

            <button class="btn-main" style="margin-top:14px;" onclick="resetPassword()">
                <i class="bi bi-check-circle"></i> Reset Password
            </button>
        </div>

    </div>
</div>

<script>
var currentEmail  = '';
var verifiedOtp   = '';
var timerInterval = null;

/* ── STEP NAVIGATION ── */
function goStep(n) {
    [1,2,3].forEach(function(i){
        document.getElementById('step'+i).classList.toggle('active', i===n);
        var dot = document.getElementById('dot'+i);
        dot.classList.toggle('active', i===n);
        dot.classList.toggle('done',   i<n);
    });
    var subtitles = ['Enter your registered email to receive a reset OTP.',
                     'Enter the 6-digit OTP sent to your email.',
                     'Choose a strong new password for your account.'];
    document.getElementById('stepSubtitle').textContent = subtitles[n-1];
    hideAlert();
}

/* ── ALERT ── */
function showAlert(type, msg) {
    var el = document.getElementById('alertBox');
    var icon = type==='ok' ? 'bi-check-circle-fill' : type==='info' ? 'bi-info-circle-fill' : 'bi-exclamation-circle-fill';
    el.className = type==='ok' ? 'alert-ok' : type==='info' ? 'alert-info' : 'alert-err';
    el.innerHTML = '<i class="bi '+icon+'"></i> ' + msg;
    el.style.display = 'flex';
}
function hideAlert() { document.getElementById('alertBox').style.display='none'; }

/* ── STEP 1: SEND OTP ── */
function submitEmail() {
    var email = document.getElementById('emailInput').value.trim();
    if (!email || !email.includes('@')) { showAlert('err','Please enter a valid email address.'); return; }
    currentEmail = email;
    /* In production: call /forgot-password-send endpoint.
       For now, simulate OTP sent successfully. */
    showAlert('ok','OTP sent successfully to ' + email + '. Check your inbox.');
    document.getElementById('emailDisplay').textContent = email;
    setTimeout(function(){ goStep(2); startTimer(); }, 1000);
}

/* ── OTP TIMER ── */
function startTimer() {
    var secs = 60;
    document.getElementById('timerCount').textContent = secs;
    document.getElementById('timerDisplay').style.display = 'block';
    document.getElementById('resendBtn').disabled = true;
    clearInterval(timerInterval);
    timerInterval = setInterval(function(){
        secs--;
        document.getElementById('timerCount').textContent = secs;
        if (secs <= 0) {
            clearInterval(timerInterval);
            document.getElementById('timerDisplay').style.display='none';
            document.getElementById('resendBtn').disabled = false;
        }
    }, 1000);
}

/* ── OTP BOX FOCUS ── */
function moveFocus(el, prevId, nextId) {
    var val = el.value.replace(/\D/g,'');
    el.value = val;
    if (val && nextId) document.getElementById(nextId).focus();
    if (!val && prevId) document.getElementById(prevId).focus();
}

/* ── STEP 2: VERIFY OTP ── */
function verifyOtp() {
    var otp = ['otp1','otp2','otp3','otp4','otp5','otp6'].map(function(id){
        return document.getElementById(id).value;
    }).join('');
    if (otp.length < 6) { showAlert('err','Please enter the complete 6-digit OTP.'); return; }
    /* In production: POST to /forgot-password-verify with email + otp */
    verifiedOtp = otp;
    showAlert('ok','OTP verified successfully!');
    setTimeout(function(){ goStep(3); }, 800);
}

/* ── RESEND OTP ── */
function resendOtp() {
    ['otp1','otp2','otp3','otp4','otp5','otp6'].forEach(function(id){ document.getElementById(id).value=''; });
    document.getElementById('otp1').focus();
    showAlert('info','A new OTP has been sent to ' + currentEmail);
    startTimer();
}

/* ── STEP 3: RESET PASSWORD ── */
function resetPassword() {
    var p1 = document.getElementById('newPwd').value;
    var p2 = document.getElementById('confirmPwd').value;
    if (p1.length < 8) { showAlert('err','Password must be at least 8 characters.'); return; }
    if (p1 !== p2)     { document.getElementById('pwdMatchErr').classList.remove('d-none'); return; }
    document.getElementById('pwdMatchErr').classList.add('d-none');
    /* In production: POST to /forgot-password-reset with email + otp + newPassword */
    showAlert('ok','Password reset successful! Redirecting to login...');
    setTimeout(function(){
        window.location.href = '<%=request.getContextPath()%>/auth/login.jsp';
    }, 2000);
}

/* ── PASSWORD STRENGTH ── */
function checkStrength(val) {
    var score = 0;
    if (val.length >= 8) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^a-zA-Z0-9]/.test(val)) score++;
    var colors = ['#dc3545','#fd7e14','#ffc107','#198754'];
    var labels = ['Weak','Fair','Good','Strong'];
    for(var i=1;i<=4;i++){
        var seg = document.getElementById('seg'+i);
        seg.style.background = i<=score ? colors[score-1] : '#e0dbd4';
    }
    document.getElementById('strengthLabel').textContent = score>0 ? 'Strength: '+labels[score-1] : '';
    document.getElementById('strengthLabel').style.color = score>0 ? colors[score-1] : '#aaa';
}

/* ── EYE TOGGLE ── */
function toggleEye(inputId, iconId) {
    var inp  = document.getElementById(inputId);
    var icon = document.getElementById(iconId);
    if (inp.type==='password') { inp.type='text'; icon.classList.replace('bi-eye-slash','bi-eye'); }
    else                       { inp.type='password'; icon.classList.replace('bi-eye','bi-eye-slash'); }
}

/* OTP paste support */
document.addEventListener('paste', function(e){
    var data = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g,'');
    if (data.length === 6) {
        ['otp1','otp2','otp3','otp4','otp5','otp6'].forEach(function(id,i){
            document.getElementById(id).value = data[i] || '';
        });
        e.preventDefault();
    }
});
</script>
</body>
</html>
