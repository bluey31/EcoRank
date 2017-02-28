package main.visualiser.shader;

import static org.lwjgl.opengl.ARBShaderObjects.*;

public class GameShader extends TextureShader {

    //Names of variables in code;
    private final String time = "time",
                 texture_enabled = "textureEnabled",
                 renderShield = "renderShield",
                 renderShieldTick = "renderShieldTick",
                 renderShieldAngle = "renderShieldAngle",
                 renderShieldHealth = "renderShieldHealth",
                 particleMode = "particleMode";

    private int timeID, textureEnabledID, renderShieldID, renderShieldTickID, renderShieldAngleID, renderShieldHealthID, particleModeID;

    public GameShader(VertexShader vertex, FragmentShader frag, String sampler2DName) {
        super(vertex, frag, sampler2DName);
        acquireIDs();
    }

    public GameShader(int program, String sampler2DName) {
        super(program, sampler2DName);
        acquireIDs();
    }

    private void acquireIDs(){
        this.timeID = glGetUniformLocationARB(this.getShaderProgram(), time);
        this.textureEnabledID = glGetUniformLocationARB(this.getShaderProgram(), texture_enabled);
        this.renderShieldID = glGetUniformLocationARB(this.getShaderProgram(), renderShield);
        this.renderShieldTickID = glGetUniformLocationARB(this.getShaderProgram(), renderShieldTick);
        this.renderShieldAngleID = glGetUniformLocationARB(this.getShaderProgram(), renderShieldAngle);
        this.renderShieldHealthID = glGetUniformLocationARB(this.getShaderProgram(), renderShieldHealth);
        this.particleModeID = glGetUniformLocationARB(this.getShaderProgram(), particleMode);
    }

    @Override
    public void unBindTexture(int texture) {
        super.unBindTexture(texture);
        setTextureEnabled(false);
    }

    @Override
    public void bindTexture(int texture) {
        super.bindTexture(texture);
        setTextureEnabled(true);
    }

    private void setShaderBoolean(int id, boolean value){
        int location = id;
        if(value == true) {
            glUniform1iARB(location, 1);
            return;
        }
        glUniform1iARB(location, 0);
    }
    private void setShaderFloat(int id, float value){
        int location = id;
        glUniform1fARB(location, value);
    }

    float timeTick = 0;
    public void incrementTime(float amount){
        timeTick += amount;
    }

    //Shortcut funcs
    public void syncTime(){
        setShaderFloat(this.timeID, timeTick);
    }
    public void setTextureEnabled(boolean value){
        setShaderBoolean(textureEnabledID, value);
    }
    public void setRenderShield(boolean value){
        setShaderBoolean(renderShieldID, value);
    }
    public void setRenderShieldTick(float tick){
        setShaderFloat(renderShieldTickID, tick);
    }
    public void setRenderShieldAngle(float angle){
        setShaderFloat(renderShieldAngleID, angle);
    }
    public void setRenderShieldHealth(float health){
        setShaderFloat(renderShieldHealthID, health);
    }
    public void setParticleMode(boolean value){
        setShaderBoolean(particleModeID, value);
    }


}
